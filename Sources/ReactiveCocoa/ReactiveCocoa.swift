//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire
import ReactiveCocoa
import enum Result.NoError

public extension Requestable {
    
    public func executeTask() -> SignalProducer<Response<Model, NSError>, NoError> {
        
        return SignalProducer { sink, _ in
            self.executeTask() { (response: Response<Model, NSError>) in
                sink.sendNext(response)
                sink.sendCompleted()
            }
        }
    }
    
}
