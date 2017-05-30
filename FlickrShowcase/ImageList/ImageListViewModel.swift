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
    private var page: Int = 1
    
    // MARK: Deisgnated Initializer
    init(callback: @escaping (State<[FlickrPhoto]>) -> ()) {
        self.callback = callback
    }
    
    // MARK: Public Methods
    func fetchPhotos(for keyword: String, shouldResetPage: Bool = false, with webService: WebService = WebService()) {
        if shouldResetPage { page = 1 }
        
        let previousState = state
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
}
