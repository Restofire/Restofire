//
//  RequestType.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire
import ReactiveCocoa

public extension RequestType {
    
    public func executeTask<Model: Any>() -> SignalProducer<Response<Model, NSError>, NSError> {
        
        return SignalProducer { sink, disposable in
            self.executeTask({ (response: Response<Model, NSError>) in
                if let error = response.result.error {
                    sink.sendFailed(error)
                } else {
                    sink.sendNext(response)
                    sink.sendCompleted()
                }
            })
            
            disposable.addDisposable {
                
            }
        }
    }
    
}
