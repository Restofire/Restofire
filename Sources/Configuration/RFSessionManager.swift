//
//  RFSessionManager.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public struct RFSessionManager {
    
    /// The default session manager.
    public static var `default` = RFSessionManager()

    /// The Alamofire Session Manager. `Alamofire.SessionManager.default` by default.
    public var sessionManager = SessionManager.default
    
    /// `RFSessionManager` Intializer
    ///
    /// - returns: new `RFSessionManager` object
    public init() {}
    
}
