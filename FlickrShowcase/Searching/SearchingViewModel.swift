//
//  SearchingViewModel.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Searching View Model
final class SearchingViewModel {
    // MARK: Properties
    private(set) var state: State<[String]> = .normal([]) {
        didSet {
            callback(state)
        }
    }

    private let userDefaults: UserDefaults
    private let callback: (State<[String]>) -> ()
    
    // MARK: Designated Initializer
    init(userDefaults: UserDefaults = UserDefaults.standard, callback: @escaping (State<[String]>) -> ()) {
        self.userDefaults = userDefaults
        self.callback = callback
    }
    
    // MARK: Public Methods
    func fetchSearchHistory() {
        state = .normal(userDefaults.searchHistory())
    }
    
    func refreshSearchHistory(with keyword: String) {
        guard var history = state.allElements else { return }
        
        history.append(keyword)
        userDefaults.set(history)
        state = .normal(history)
    }
}

// MARK: - User Defaults Extension
extension UserDefaults {
    private static let searchHistoryKey = "SearchHistoryKey"
    
    @discardableResult
    func set(_ searchHistory: [String]) -> Bool {
        set(searchHistory, forKey: UserDefaults.searchHistoryKey)
        return synchronize()
    }
    
    func searchHistory() -> [String] {
        return array(forKey: UserDefaults.searchHistoryKey) as? [String] ?? []
    }
}
