//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RequestEventuallyQueue {
    
    private var queue = [RequestEventually]()
    private let networkReachabilityManager = NetworkReachabilityManager()
    
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
    
    private func startListeningForNetworkChanges() {
        if let manger = networkReachabilityManager where !manger.startListening() {
            startListeningForNetworkChanges()
        }
    }
    
    func enqueuRequestEventually(requestEventually: RequestEventually) {
        if let manager = networkReachabilityManager where manager.isReachable {
            self.executeRequestEventually(requestEventually)
        } else {
            queue.append(requestEventually)
        }
    }
    
    private func startExecutingQueue() {
        for (index, requestEventually) in queue.enumerate() {
            if let manager = networkReachabilityManager where manager.isReachable {
                self.executeRequestEventually(requestEventually, atIndex: index)
            } else { break }
        }
    }
    
    private func executeRequestEventually(requestEventually: RequestEventually, atIndex index: Int = -1) {
        if requestEventually.maxAttempts > 0 {
            requestEventually.request.executeTask({ (response: Response<AnyObject, NSError>) in
                if response.result.error == nil {
                    requestEventually.requestCompletionHandler(response)
                    if index != -1 { self.queue.removeAtIndex(index) }
                } else {
                    requestEventually.maxAttempts -= 1
                    if index == -1 { self.queue.append(requestEventually) }
                }
            })
        } else {
            self.queue.removeAtIndex(index)
        }
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
    
}
