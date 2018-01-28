//
//  ResponseSerializer.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public struct ResponseSerializer {
    
    /// The default authentication.
    public static var `default` = ResponseSerializer()
    
    /// The data response serializer. `nil` by default.
    public var data: DataResponseSerializer<Any> = DataRequest.jsonResponseSerializer()
    
    /// The download response serializer. `nil` by default.
    public var download: DownloadResponseSerializer<Any> = DownloadRequest.jsonResponseSerializer()
    
    /// `Authentication` Intializer
    ///
    /// - returns: new `Authentication` object
    public init() {}
    
}
