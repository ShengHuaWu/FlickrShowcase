//
//  ImageListViewModel.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List View Model
final class ImageListViewModel {
    // MARK: Properties
    private(set) var state: State<[FlickrPhoto]> = .normal([]) {
        didSet {
            callback(state)
        }
    }
    
    private let imageProvider: ImageProvider
    private let callback: (State<[FlickrPhoto]>) -> ()
    private var page: Int = 1
    private var keyword: String = ""
    
    // MARK: Deisgnated Initializer
    init(imageProvider: ImageProvider = ImageProvider(), callback: @escaping (State<[FlickrPhoto]>) -> ()) {
        self.imageProvider = imageProvider
        self.callback = callback
    }
    
    // MARK: Public Methods
    func fetchPhotos(for newKeyword: String? = nil, shouldReset: Bool = false, with webService: WebService = WebService()) {
        newKeyword.flatMap{ keyword = $0 }
        page = shouldReset ? 1 : page
        
        let previousState = shouldReset ? .normal([]) : state
        state = .loading
        
        webService.load(resource: flickrPhotos(at: page, for: keyword)) { (result) in
            switch result {
            case let .success(photos):
                self.page += 1
                self.state = previousState.append(newValues: photos)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
    
    func downloadImage(at indexPath: IndexPath, with completion: @escaping (URL) -> ()) {
        guard let photo = state.element(at: indexPath.item) else { return }
        
        imageProvider.load(photo.url, for: photo.flickrID) { (result) in
            switch result {
            case let .success(url):
                completion(url)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func suspendDownloadingImage() {
        imageProvider.suspendLoading()
    }
    
    func resumeDownloadingImage() {
        imageProvider.resumeLoading()
    }
}

// MARK: - Flickr Photo Extension
extension FlickrPhoto {
    var url: URL {
        return URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(flickrID)_\(secret).jpg")!
    }
}
