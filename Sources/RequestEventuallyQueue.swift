//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

public class RequestEventuallyQueue<Element> {
    
    static let defaultQueue = RequestEventuallyQueue()
    var requestEventuallyQueue = [AnyRequestable<Element>]()
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
    
    func enqueuRequest(request: AnyRequestable<Element>) {
        requestEventuallyQueue.append(request)
    }
    
    func startExecutingQueue() {
        for request in requestEventuallyQueue {
            if let manager = networkReachabilityManager where manager.isReachable {
                self.executeRequest(request)
            } else { break }
        }
    }
    
    func executeRequest(request: AnyRequestable<Element>) {
        request.executeTask { (response: Response<Element, NSError>) in
            if let _ = response.result.error {
                
            } else {
                
            }
        }
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
    
}
