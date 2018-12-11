//
//  Restofire+RequestLogging.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    
    @discardableResult
    func logIfNeeded() -> Request {
        underlyingQueue.async {
            if let argumentIndex = ProcessInfo.processInfo.arguments
                .index(of: "-org.restofire.Restofire.Debug") {
                let logLevel = ProcessInfo.processInfo.arguments[argumentIndex+1]
                if logLevel == "1" {
                    print(self.debugDescription)
                }
            }
        }
        return self
    }
    
}
