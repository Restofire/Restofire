//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol Requestable: ARequestable, Configurable {

    func didStart(request: DataRequest)
    
    func didComplete(request: DataRequest, with: DefaultDataResponse)
}

public extension Requestable {
    
    /// `Does Nothing`
    func didStart(request: DataRequest) {}
    
    /// `Does Nothing`
    func didComplete(request: DataRequest, with: DefaultDataResponse) {}
    
}

public protocol FileUploadable: AFileUploadable, Requestable {}
public protocol DataUploadable: ADataUploadable, Requestable {}
public protocol StreamUploadable: AStreamUploadable, Requestable {}
public protocol MultipartUploadable: AMultipartUploadable, Requestable {}
