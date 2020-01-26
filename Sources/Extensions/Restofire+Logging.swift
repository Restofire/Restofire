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
            .firstIndex(of: "-org.restofire.Restofire.Debug") {
            let logLevel = ProcessInfo.processInfo.arguments[argumentIndex+1]
            delegate.queue.addOperation {
                if logLevel == "1" {
                    print(self.debugDescription)
                }
            }
        }
        return self
    }
    
}
