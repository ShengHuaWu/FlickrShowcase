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
    private(set) var state: State<[URL]> = .normal([]) {
        didSet {
            callback(state)
        }
    }
    
    private let callback: (State<[URL]>) -> ()
    
    // MARK: Deisgnated Initializer
    init(callback: @escaping (State<[URL]>) -> ()) {
        self.callback = callback
    }
}
