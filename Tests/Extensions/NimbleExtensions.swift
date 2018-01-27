//
//  NimbleExtensions.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Nimble

/// A Nimble matcher that succeeds when the actual value is nil.
public func beNonNil<T>() -> Predicate<T> {
    return Predicate.simpleNilable("be non nil") { actualExpression in
        let actualValue = try actualExpression.evaluate()
        return PredicateStatus(bool: actualValue != nil)
    }
}

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    extension NMBObjCMatcher {
        @objc public class func beNonNilMatcher() -> NMBObjCMatcher {
            return NMBObjCMatcher { actualExpression, failureMessage in
                return try! beNonNil().matches(actualExpression, failureMessage: failureMessage)
            }
        }
    }
#endif
