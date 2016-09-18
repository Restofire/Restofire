//
//  DictionaryUtils.swift
//  Restofire
//
//  Created by Rahul Katariya on 18/09/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

func + <T, U>(lhs: [T: U]?, rhs: [T: U]?) -> [T: U]? {
    
    guard let lhs = lhs else { return rhs }
    guard let rhs = rhs else { return lhs }
    
    var merged = lhs
    for (key, val) in rhs {
        merged[key] = val
    }
    
    return merged
}
