//
//  AUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Uploadable` for Alamofire.
///
/// Use sub protocols - AFileUploadable, ADataUploadable, AStreamUploadable,
/// AMultipartUplodable
public protocol _AUploadable: ARequestable {}

public extension _AUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

