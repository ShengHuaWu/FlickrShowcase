//
//  ImageListViewModel.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

final class ImageListViewModel {
    // MARK: Properties
    private(set) var state: State<[FlickrPhoto]> = .normal([]) {
        didSet {
            callback(state)
        }
    }
    
    private let callback: (State<[FlickrPhoto]>) -> ()
    
    // MARK: Deisgnated Initializer
    init(callback: @escaping (State<[FlickrPhoto]>) -> ()) {
        self.callback = callback
    }
    
    // MARK: Public Methods
    func fetchPhotos(at page: Int = 1, for keyword: String, with webService: WebService = WebService()) {
        webService.load(resource: flickrPhotos(at: page, for: keyword)) { (result) in
            switch result {
            case let .success(photos):
                self.state = .normal(photos)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
}
