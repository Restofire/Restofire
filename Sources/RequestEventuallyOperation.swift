//
//  RequestEventuallyOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public class RequestEventuallyOperation: RequestOperation {

    private let networkReachabilityManager = NetworkReachabilityManager()
    
    public override init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)?) {
        super.init(requestable: requestable, completionHandler: completionHandler)
        networkReachabilityManager?.listener = { status in
            switch status {
            case .Reachable(_):
                self.ready = true
            default:
                self.ready = false
                break
            }
        }
        startListeningForNetworkChanges()
    }
    
    private func startListeningForNetworkChanges() {
        if let manger = networkReachabilityManager where !manger.startListening() {
            startListeningForNetworkChanges()
        }
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
