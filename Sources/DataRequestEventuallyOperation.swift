//
//  DataRequestEventuallyOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

#if !os(watchOS)

import Foundation

/// A `DataRequestOperation`, when added to an `NSOperationQueue` moitors the 
/// network reachability and executes the `Requestable` when the network
/// is reachable.
///
/// - Note: Do not call `start()` directly instead add it to an `NSOperationQueue`
/// because calling `start()` will begin the execution of work regardless of network reachability
/// which is equivalant to `DataRequestOperation`.
open class DataRequestEventuallyOperation<R: Requestable>: DataRequestOperation<R> {

    fileprivate let networkReachabilityManager = NetworkReachabilityManager()
    
    override init(requestable: R, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
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
    
    override func handleErrorDataResponse(_ response: DataResponse<R.Response>) {
        if let error = response.result.error as? URLError, self.retryAttempts > 0 {
            if error.code == .notConnectedToInternet {
                self.pause = true
            } else if self.requestable.retryErrorCodes.contains(error.code) {
                self.retryAttempts -= 1
                self.perform(#selector(DataRequestOperation<R>.executeRequest), with: nil, afterDelay: self.requestable.retryInterval)
            }
        } else {
           super.handleErrorDataResponse(response)
        }
    }

}

#endif
