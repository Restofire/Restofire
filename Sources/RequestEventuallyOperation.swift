//
//  RequestEventuallyOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// RequestEventuallyOperation represents an RequestOperation object which executes
/// asynchronously when the network is reachable.
public class RequestEventuallyOperation: RequestOperation {

    private let networkReachabilityManager = NetworkReachabilityManager()
    
    override init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)?) {        
        super.init(requestable: requestable, completionHandler: completionHandler)
        self.ready = false
        networkReachabilityManager?.listener = { status in
            switch status {
            case .Reachable(_):
                if self.pause {
                    self.resume = true
                } else {
                    self.ready = true
                }
            default:
                self.pause = true
            }
        }
        networkReachabilityManager?.startListening()
    }
    
    override func executeRequest() {
        request.response(rootKeyPath: requestable.rootKeyPath) { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                self.successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else if self.retryAttempts > 0 {
                if response.result.error!.code == NSURLErrorNotConnectedToInternet {
                    self.pause = true
                } else if self.requestable.retryErrorCodes.contains(response.result.error!.code) {
                    self.retryAttempts -= 1
                    self.performSelector(#selector(RequestOperation.startRequest), withObject: nil, afterDelay: self.requestable.retryInterval)
                }
            } else {
                self.failed = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            }
            if self.requestable.logging { debugPrint(response) }
        }
    }

}
