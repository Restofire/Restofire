// pure merge for Dictionaries
func + <T, U>(var lhs: [T: U]?, rhs: [T: U]?) -> [T: U]? {
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
