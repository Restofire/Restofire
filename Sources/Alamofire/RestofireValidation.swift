//
//  Restofire+AlamofireValidation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

class RestofireRequestValidation {
    
    static func validateDataRequest(request: DataRequest, requestable: ARequestable) {
        validateDataRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateDataRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateDataRequest(request, forValidation: requestable.validationBlock)
    }
    
    static func validateDataRequest(_ request: DataRequest, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    static func validateDataRequest(_ request: DataRequest, forAcceptableStatusCodes statusCodes:[Int]?) {
        guard let statusCodes = statusCodes else { return }
        request.validate(statusCode: statusCodes)
    }
    
    static func validateDataRequest(_ request: DataRequest, forValidation validation:DataRequest.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }

}

class RestofireDownloadValidation {
    
    static func validateDownloadRequest(request: DownloadRequest, requestable: ADownloadable) {
        validateDownloadRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateDownloadRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateDownloadRequest(request, forValidation: requestable.validationBlock)
    }
    
    static func validateDownloadRequest(_ request: DownloadRequest, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    static func validateDownloadRequest(_ request: DownloadRequest, forAcceptableStatusCodes statusCodes:[Int]?) {
        guard let statusCodes = statusCodes else { return }
        request.validate(statusCode: statusCodes)
    }
    
    static func validateDownloadRequest(_ request: DownloadRequest, forValidation validation:DownloadRequest.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}
