//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RequestEventuallyQueue {
    
    var queue = [RequestEventually]()
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
    
    func enqueuRequestEventually(requestEventually: RequestEventually) {
        if let manager = networkReachabilityManager where manager.isReachable {
            requestEventually.request.executeTask({ (response: Response<AnyObject, NSError>) in
                requestEventually.requestCompletionHandler(response)
            })
        } else {
            queue.append(requestEventually)
        }
    }
    
    func startExecutingQueue() {
        for request in queue {
            if let manager = networkReachabilityManager where manager.isReachable {
                self.executeRequestEventually(request)
            } else { break }
        }
    }
    
    func executeRequestEventually(requestEventually: RequestEventually) {
        requestEventually.request.executeTask { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {

            } else { }
        }
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
    
}
