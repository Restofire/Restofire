//
//  AUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol _AUploadable: _Requestable, AConfigurable {
    
    /// The Alamofire data request validation.
    var validationBlock: DataRequest.Validation? { get }
    
}

public extension _AUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
    /// `configuration.dataValidation`
    public var validationBlock: DataRequest.Validation? {
        return validation.dataValidation
    }
    
}

