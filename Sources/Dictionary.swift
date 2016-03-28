// pure merge for Dictionaries
func + <T, U>(lhs: [T: U]?, rhs: [T: U]?) -> [T: U]? {
    var lhs = lhs
    if rhs == nil {
        return lhs
    } else if lhs == nil {
        return rhs
    } else {
        for (key, val) in rhs! {
            lhs![key] = val
        }
        return lhs
    }
}

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