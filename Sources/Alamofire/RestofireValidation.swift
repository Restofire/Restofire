//
//  Restofire+AlamofireValidation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

class RestofireRequestValidation {
    
    static func validateDataRequest<R: Requestable>(request: DataRequest, requestable: R) {
        validateDataRequest(request, forAcceptableContentTypes: requestable.validation.acceptableContentTypes)
        validateDataRequest(request, forAcceptableStatusCodes: requestable.validation.acceptableStatusCodes)
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
    
    static func validateDownloadRequest<R: Downloadable>(request: DownloadRequest, requestable: R) {
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

class RestofireUploadValidation {
    
    static func validateUploadRequest<R: Uploadable>(request: UploadRequest, requestable: R) {
        validateUploadRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateUploadRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateUploadRequest(request, forValidation: requestable.validationBlock)
    }
    
    static func validateUploadRequest(_ request: UploadRequest, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    static func validateUploadRequest(_ request: UploadRequest, forAcceptableStatusCodes statusCodes:[Int]?) {
        guard let statusCodes = statusCodes else { return }
        request.validate(statusCode: statusCodes)
    }
    
    static func validateUploadRequest(_ request: UploadRequest, forValidation validation:DataRequest.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}
