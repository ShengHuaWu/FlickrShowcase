//
//  ImageProvider.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image Provider
final class ImageProvider {
    // MARK: Properties
    private let fileManager: FileManager
    private let userDefaults: UserDefaults
    private let operationQueue = OperationQueue()
    
    // MARK: Designated Initializer
    init(fileManager: FileManager = FileManager.default, userDefaults: UserDefaults = UserDefaults.standard) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
    }
    
    // MARK: Public Methods
    static func setUp(with fileManager: FileManager = FileManager.default, userDefaults: UserDefaults = UserDefaults.standard) {
        guard userDefaults.temporaryDirectoryURL() == nil else { return }
        
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uniqueString, isDirectory: true)
        try! fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        userDefaults.setTemporaryDirectoryURL(directoryURL)
    }
    
    func load(_ url: URL, for identifier: String, with completion: @escaping (Result<URL>) -> ()) {
        guard let directoryURL = userDefaults.temporaryDirectoryURL() else { return }
        
        let fileURL = directoryURL.appendingPathComponent(identifier)
        if fileManager.fileExists(atPath: fileURL.path) {
            completion(.success(fileURL))
        } else {
            guard !operationQueue.isSuspended else { return }
            
            operationQueue.addOperation {
                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: fileURL, options: .atomic)
                    
                    OperationQueue.main.addOperation {
                        completion(.success(fileURL))
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func suspendLoading() {
        operationQueue.isSuspended = true
        operationQueue.cancelAllOperations()
    }
    
    func resumeLoading() {
        operationQueue.isSuspended = false
    }
}

// MARK: - User Defaults Extension
extension UserDefaults {
    private static let temporaryDirectoryURLKey = "TemporaryDirectoryURLKey"
    
    @discardableResult
    func setTemporaryDirectoryURL(_ url: URL) -> Bool {
        set(url, forKey: UserDefaults.temporaryDirectoryURLKey)
        return synchronize()
    }
    
    func temporaryDirectoryURL() -> URL? {
        return url(forKey: UserDefaults.temporaryDirectoryURLKey)
    }
}
