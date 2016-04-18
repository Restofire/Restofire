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
/// It gets its ready state when the network is reachable.
public class RequestEventuallyOperation: RequestOperation {

    private let networkReachabilityManager = NetworkReachabilityManager()
    
    public override init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)?) {
        super.init(requestable: requestable, completionHandler: completionHandler)
        retry = true
        attempts = requestable.maxRetryAttempts
        networkReachabilityManager?.listener = { status in
            switch status {
            case .Reachable(_):
                if self.pause {
                    self.executeRequest()
                    self.pause = false
                } else {
                    self.ready = true
                }
            default:
                self.pause = true
            }
        }
        networkReachabilityManager?.startListening()
    }
    
    var _ready: Bool = false
    public override var ready: Bool {
        get {
            return _ready
        }
        set (newValue) {
            willChangeValueForKey("isReady")
            _ready = newValue
            didChangeValueForKey("isReady")
        }
    }

}
