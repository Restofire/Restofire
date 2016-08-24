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
open class RequestEventuallyOperation<R: Requestable>: RequestOperation<R> {

    fileprivate let networkReachabilityManager = NetworkReachabilityManager()
    override init(requestable: R, completionHandler: ((Response<R.Model, NSError>) -> Void)?) {
        super.init(requestable: requestable, completionHandler: completionHandler)
        self.isReady = false
        networkReachabilityManager?.listener = { status in
            switch status {
            case .reachable(_):
                if self.pause {
                    self.resume = true
                } else {
                    self.isReady = true
                }
            default:
                if self.isFinished == false && self.isExecuting == false {
                    self.isReady = false
                } else {
                    self.pause = true
                }
            }
        }
        networkReachabilityManager?.startListening()
    }
    
    override func handleErrorResponse(_ response: Response<R.Model, NSError>) {
        if self.retryAttempts > 0 {
            if response.result.error!.code == NSURLErrorNotConnectedToInternet {
                self.pause = true
            } else if self.requestable.retryErrorCodes.contains(response.result.error!.code) {
                self.retryAttempts -= 1
                self.perform(#selector(RequestOperation<R>.executeRequest), with: nil, afterDelay: self.requestable.retryInterval)
            }
        } else {
           super.handleErrorResponse(response)
        }
    }

}

#endif
