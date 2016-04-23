//
//  RequestEventuallyOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

#if !os(watchOS)

import Foundation
import Alamofire

/// A `RequestOperation`, when added to an `NSOperationQueue` moitors the 
/// network reachability and executes the `Requestable` when the network
/// is reachable.
///
/// - Note: Do not call `start()` directly instead add it to an `NSOperationQueue`
/// because calling `start()` will begin the execution of work regardless of network reachability
/// which is equivalant to `RequestOperation`.
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
                if self.finished == false && self.executing == false {
                    self.ready = false
                } else {
                    self.pause = true
                }
            }
        }
        networkReachabilityManager?.startListening()
    }
    
    override func handleErrorResponse(response: Response<AnyObject, NSError>) {
        if self.retryAttempts > 0 {
            if response.result.error!.code == NSURLErrorNotConnectedToInternet {
                self.pause = true
            } else if self.requestable.retryErrorCodes.contains(response.result.error!.code) {
                self.retryAttempts -= 1
                self.performSelector(#selector(RequestOperation.executeRequest), withObject: nil, afterDelay: self.requestable.retryInterval)
            }
        } else {
           super.handleErrorResponse(response)
        }
    }

}

#endif
