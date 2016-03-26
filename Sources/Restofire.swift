//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/10/15.
//  Copyright © 2015 AarKay. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

public class Restofire {
    
    public init() {}
    
    public func executeRequest<T>(object: RestofireProtocol,
                               completionHandler: Response<T, NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
            completionHandler(response)
            if object.logging {
                print(response.request.debugDescription)
                print(response.timeline)
                print(response.response)
                if response.result.isSuccess {
                    print(response.result.value!)
                } else {
                    print(response.result.error!)
                }
            }
        }
    }
    
    public func executeRequest<T: Decodable>(object: RestofireProtocol,
                               completionHandler: Response<T, NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
            completionHandler(response)
            if object.logging {
                print(response.request.debugDescription)
                print(response.timeline)
                print(response.response)
                if response.result.isSuccess {
                    print(response.result.value!)
                } else {
                    print(response.result.error!)
                }
            }
        }
    }
    
    public func executeRequest<T: Decodable>(object: RestofireProtocol,
                               completionHandler: Response<[T], NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<[T], NSError>) -> Void in
            completionHandler(response)
            if object.logging {
                print(response.request.debugDescription)
                print(response.timeline)
                print(response.response)
                if response.result.isSuccess {
                    print(response.result.value!)
                } else {
                    print(response.result.error!)
                }
            }
        }
        
    }
    
}
