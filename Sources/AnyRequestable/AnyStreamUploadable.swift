//
//  AnyStreamUploadable.swift
//  Restofire
//
//  Created by RahulKatariya on 08/08/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public struct AnyStreamUploadable<T>: StreamUploadable {
    
    public typealias Response = T
    
    public let uuid: String? = UUID().uuidString
    public let path: String?
    public let stream: InputStream
    public let requestDelegates: [RequestDelegate]
    public let responseSerializer: AnyResponseSerializer<Result<AnyRequestable<T>.Response>>
    public let configuration: Configuration
    public let session: Session
    public let authentication: Authentication
    public let retry: Retry
    public let validation: Validation
    public let reachability: Reachability
    
    init(path: String,
         stream: InputStream,
         requestDelegates: [RequestDelegate] = Configuration.default.requestDelegates,
         responseSerializer: AnyResponseSerializer<Result<AnyRequestable<T>.Response>>,
         configuration: Configuration = Configuration.default,
         session: Session = Session.default,
         authentication: Authentication = Authentication.default,
         retry: Retry = Retry.default,
         validation: Validation = Validation.default,
         reachability: Reachability = Reachability.default) {
        self.path = path
        self.stream = stream
        self.requestDelegates = requestDelegates
        self.responseSerializer = responseSerializer
        self.configuration = configuration
        self.session = session
        self.authentication = authentication
        self.retry = retry
        self.validation = validation
        self.reachability = reachability
    }
    
}
