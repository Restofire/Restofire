//
//  PersonGETService.swift
//  Example
//
//  Created by Rahul Katariya on 28/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import Foundation
import Restofire

struct PersonGETService: Requestable {
    
    typealias Model = [String: AnyObject]
    let path: String = "56c2cc70120000c12673f1b5"
    
}

// MARK: - Callbacks
import Alamofire

extension PersonGETService {

    func didStartRequest() {
        print("Request Started")
    }
    
    func didCompleteWithResponse(response: Response<Model, NSError>) {
        print(response)
    }
    
}
