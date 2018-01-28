//
//  SessionManagable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.SessionManager` that is associated with `Configurable`.
/// `configuration.sessionManager` by default.
///
/// ### Create custom SessionManagable
/// ```swift
/// protocol HTTPBinSessionManagable: SessionManagable { }
///
/// extension HTTPBinSessionManagable {
///
///   var sessionManager: Alamofire.SessionManager {
///     let sessionConfiguration = URLSessionConfiguration.default
///     sessionConfiguration.timeoutIntervalForRequest = 7
///     sessionConfiguration.timeoutIntervalForResource = 7
///     sessionConfiguration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
///     return Alamofire.SessionManager(configuration: sessionConfiguration)
///   }
///
/// }
/// ```
///
/// ### Using the above SessionManagable
/// ```swift
/// class HTTPBinStringGETService: _Requestable, HTTPBinSessionManagable {
///
///   let path: String = "get"
///   let encoding: ParameterEncoding = URLEncoding.default
///   var parameters: Any?
///
///   init(parameters: Any?) {
///     self.parameters = parameters
///   }
///
/// }
/// ```
public protocol SessionManagable {
    
    /// The `sessionManager`.
    var _sessionManager: SessionManager { get }
    
}

public extension SessionManagable where Self: AConfigurable {
    
    /// `RFSessionManager.default`
    public var _sessionManager: SessionManager {
        return RFSessionManager.default.sessionManager
    }
    
}
