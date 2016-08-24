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
/// authentication.credential = NSURLCredential(user: "user", password: "password", persistence: .ForSession)
/// ```
public struct Authentication {
    
    /// The credential. `nil` by default.
    public var credential: URLCredential?
    
}
