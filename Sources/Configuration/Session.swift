//
//  Session.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// A Session for RESTful Services.
///
/// ```swift
/// var session = Session()
/// configuration.sessionManager = {
///     let sessionConfiguration = URLSessionConfiguration.default
///     sessionConfiguration.timeoutIntervalForRequest = 7
///     sessionConfiguration.timeoutIntervalForResource = 7
///     sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
///     return Alamofire.SessionManager(configuration: sessionConfiguration)
/// }
/// ```
public struct AlamofireSession {
    
    /// The default session manager.
    public static var `default` = AlamofireSession()

    /// The Alamofire Session Manager. `Alamofire.Session.default` by default.
    public var session = Session.default
    
    /// `Session` Intializer
    ///
    /// - returns: new `Session` object
    public init() {}
    
}
