//
//  State.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

enum State<T> {
    case loading
    case normal(T)
    case error(Error)
}

extension State where T: RangeReplaceableCollection {
    var count: T.IndexDistance {
        switch self {
        case let .normal(values): return values.count
        default: return 0
        }
    }
    
    var allElements: T? {
        switch self {
        case let .normal(values): return values
        default: return nil
        }
    }
    
    func element(at index: T.Index) -> T.Iterator.Element? {
        switch self {
        case let .normal(values): return values[index]
        default: return nil
        }
    }
    
    func append(newElements: T) -> State {
        switch self {
        case let .normal(elements):
            return .normal(elements + newElements)
        default:
            return .normal(newElements)
        }
    }
}
