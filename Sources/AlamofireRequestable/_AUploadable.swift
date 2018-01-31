//
//  AUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents an abstract `Uploadable` for Alamofire.
///
/// Instead implement AFileUploadable, ADataUploadable, AStreamUploadable,
/// AMultipartUplodable protocols.
public protocol _AUploadable: ARequestable {
    
    /// The uplaod request for subclasses to provide the implementation.
    var request: UploadRequest { get }
    
}

public extension _AUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

