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
/// Session.default.session = {
///     let sessionConfiguration = URLSessionConfiguration.default
///     sessionConfiguration.timeoutIntervalForRequest = 7
///     sessionConfiguration.timeoutIntervalForResource = 7
///     sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
///     return Alamofire.Session(configuration: sessionConfiguration)
/// }
/// ```
public struct Session {
    
    /// The default session manager.
    public static var `default` = Session()

    /// The Alamofire Session. `Alamofire.Session.default` by default.
    public var session = Alamofire.Session.default
    
    /// `Session` Intializer
    ///
    /// - returns: new `Session` object
    public init() {}
    
}
