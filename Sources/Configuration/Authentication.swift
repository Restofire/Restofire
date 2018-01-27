//
//  Authentication.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// A Authentication of RESTful Services.
///
/// ```swift
/// var authentication = Authentication()
/// authentication.credential = URLCredential(user: "user", password: "password", persistence: .forSession)
/// ```
public struct Authentication {
    
    /// The credential. `nil` by default.
    public var credential: URLCredential?
    
    /// `Authentication` Intializer
    ///
    /// - returns: new `Authentication` object
    public init() {}
    
}
