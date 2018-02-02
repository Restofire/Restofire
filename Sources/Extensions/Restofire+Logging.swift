//
//  Restofire+RequestLogging.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

extension Request {
    
    @discardableResult
    func logIfNeeded() -> Request {
        if let argumentIndex = ProcessInfo.processInfo.arguments
            .index(of: "-org.restofire.Restofire.Debug") {
            let logLevel = ProcessInfo.processInfo.arguments[argumentIndex+1]
            delegate.queue.addOperation {
                if logLevel == "1" {
                    print(self.debugDescription)
                } else if logLevel == "2" {
                    print(self.debugDescription)
                    print(self.response?.description ?? "Response not found")
                } else if logLevel == "3" {
                    print(self.debugDescription)
                    print(self.response?.description ?? "Unknown Response")
                }
            }
        }
        return self
    }
    
}
