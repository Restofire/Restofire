//
//  Dictionary.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

extension Dictionary {

    public func valueForKeyPath(keyPath: String) -> AnyObject? {
        let delimiter = "."
        var keys = keyPath.componentsSeparatedByString(delimiter)
        
        guard let first = keys.first as? Key else {
            print("[Restofire] Unable to use string as key on type: \(Key.self)")
            return nil
        }
        
        guard let subDict = self[first] as? [String: AnyObject] else {
            return nil
        }
        
        keys.removeAtIndex(0)
        
        if !keys.isEmpty {
            let rejoined = keys.joinWithSeparator(delimiter)
            
            return subDict.valueForKeyPath(rejoined)
        }
        
        return subDict
    }
    
}