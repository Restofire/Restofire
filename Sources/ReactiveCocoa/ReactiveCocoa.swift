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
    
    public func executeRequest() -> SignalProducer<Model, NSError> {
        
        let request = alamofireRequest()
        let keyPath = rootKeyPath
        
        return SignalProducer { sink, disposable in
            request.responseJSON(rootKeyPath: keyPath) { (response: Response<Model, NSError>) -> Void in
                if let error = response.result.error {
                    sink.sendFailed(error)
                } else {
                    sink.sendNext(response.result.value!)
                    sink.sendCompleted()
                }
                if self.logging { self.logResponse(response) }
            }
            
            disposable.addDisposable {
                request.cancel()
            }
            
        }
    }
    
}
