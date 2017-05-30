//
//  WebService.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Result
enum Result<T> {
    case success(T)
    case failure(Error)
}

// MARK: - Resource
struct Resource<T> {
    let url: URL
    let parser: (Data) throws -> T
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) throws -> T) {
        self.url = url
        self.parser = { data in
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return try parseJSON(json)
        }
    }
}

// MARK: - Web Service
final class WebService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ()) {
        session.dataTask(with: resource.url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                // TODO: Sanitize url response and data
                if let data = data {
                    do {
                        let result = try resource.parser(data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
}
