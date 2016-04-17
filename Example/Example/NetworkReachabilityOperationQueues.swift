//
//  NetworkReachabilityOperationQueues.swift
//  Example
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Alamofire

class NetworkReachabilityQueue {

    static let defaultManager = NetworkReachabilityQueue()
    private let networkReachabilityManager = NetworkReachabilityManager()
    
    init() {
        networkReachabilityManager?.listener = { status in
            switch status {
            case .Reachable(_):
               print("Network is reachable")
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

}
