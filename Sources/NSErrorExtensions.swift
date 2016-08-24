//
//  NSErrorExtensions.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/08/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

extension NSError {
    convenience init(domain: String = ErrorDomain, code: ErrorCode, failureReason: String) {
        self.init(domain: domain, code: code.rawValue, failureReason: failureReason)
    }
    
    convenience init(domain: String = ErrorDomain, code: Int, failureReason: String) {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
