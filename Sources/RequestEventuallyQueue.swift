//
//  RequestEventuallyQueue.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

public class RequestEventuallyQueue {
    
    var q: RequestType!
    var queue = [RequestType]()
    let networkReachabilityManager = NetworkReachabilityManager()
    
    init() {
        networkReachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            
        }
        
        networkReachabilityManager?.startListening()
    }
    
    
    func queueStart() {
        q.executeTask { (response: Response<Any, NSError>) in
            
        }
    }
}