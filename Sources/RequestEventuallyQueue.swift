//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RequestEventuallyQueue {
    
    var queue = [Request]()
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
    
    func enqueuRequest(request: Request) {
        queue.append(request)
    }
    
    func startExecutingQueue() {
        for request in queue {
            if let manager = networkReachabilityManager where manager.isReachable {
                self.executeRequest(request)
            } else { break }
        }
    }
    
    func executeRequest(request: Request) {
        request.executeTask { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                request.requestCompletionHandler!(response)
            } else {
                
            }
        }
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
    
}
