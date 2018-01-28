//
//  Session.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public struct Session {
    
    /// The default session manager.
    public static var `default` = Session()

    /// The Alamofire Session Manager. `Alamofire.SessionManager.default` by default.
    public var sessionManager = SessionManager.default
    
    /// `Session` Intializer
    ///
    /// - returns: new `Session` object
    public init() {}
    
}
