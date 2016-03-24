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
    
    private var configuration: Configuration!
    
    public init(configuration: Configuration = Configuration.defaultConfiguration) {
        self.configuration = configuration
    }
    
    public func executeRequest<T>(object: RestofireProtocol,
                               completionHandler: Response<T, NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
            completionHandler(response)
            if self.configuration.logging {
                print(request.debugDescription)
                print(response)
            }
        }
    }
    
    public func executeRequest<T: Decodable>(object: RestofireProtocol,
                               completionHandler: Response<T, NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
            completionHandler(response)
            if self.configuration.logging {
                print(request.debugDescription)
                print(response)
            }
        }
    }
    
    public func executeRequest<T: Decodable>(object: RestofireProtocol,
                               completionHandler: Response<[T], NSError> -> Void) {
        
        let request = Utils.alamofireRequest(object)
        request.responseGLOSS(rootKey: object.rootKey) { (response: Response<[T], NSError>) -> Void in
            completionHandler(response)
            if self.configuration.logging {
                print(request.debugDescription)
                print(response)
            }
        }
        
    }
    
}
