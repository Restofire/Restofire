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
        let debug = ProcessInfo.processInfo.environment["-me.rahulkatariya.Restofire.Debug"]
        delegate.queue.addOperation {
            if debug == "1" {
                print(self.debugDescription)
            } else if debug == "2" {
                print(self.debugDescription)
                print(self.response?.description ?? "Unknown Response")
            } else if debug == "3" {
                print(self.debugDescription)
                print(self.request?.description ?? "Unknown Request")
                print(self.response?.description ?? "Unknown Response")
            }
        }
        return self
    }
    
}
