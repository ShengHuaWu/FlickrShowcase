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

extension State where T: Collection {
    var count: T.IndexDistance {
        switch self {
        case let .normal(values): return values.count
        default: return 0
        }
    }
    
    func value(at index: T.Index) -> T.Iterator.Element? {
        switch self {
        case let .normal(values): return values[index]
        default: return nil
        }
    }
    
    func append(newValues: T) -> State {
        switch self {
        case let .normal(values):
            let merged = [values, newValues].flatMap{ $0 }
            return .normal(merged as! T)
        default: return .normal(newValues)
        }
    }
}
