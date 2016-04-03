//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

public class RequestEventuallyQueue {
    
    var requestEventuallyQueue = [Requestable]()
    let networkReachabilityManager = NetworkReachabilityManager()
    
    init() {
        networkReachabilityManager?.listener = { status in
            switch status {
            case .Reachable(_):
                self.startExecutingQueue()
            default:
                break
            }
        }
        startListeningForNetworkChanges()
    }
    
    func startListeningForNetworkChanges() {
        if let manger = networkReachabilityManager where !manger.startListening() {
            startListeningForNetworkChanges()
        }
    }
    
    public func enqueuRequestable(requestable: Requestable) {
        requestEventuallyQueue.append(requestable)
    }
    
    func startExecutingQueue() {
        for request in requestEventuallyQueue {
            if let manager = networkReachabilityManager where manager.isReachable {
                self.executeRequest(request)
            } else { break }
        }
    }
    
    func executeRequest(request: Requestable) {
        request.executeTask { (response: Response<Any, NSError>) in
            if let _ = response.result.error {
                
            } else {
                
            }
        }
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
    
}
