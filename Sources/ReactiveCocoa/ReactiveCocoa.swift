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
        
        return SignalProducer { [weak self] sink, disposable in
            guard let weakSelf = self else { return }
            weakSelf.executeRequest({ (result: Response<Model, NSError>) in
                if let error = result.error {
                    sink.sendFailed(error)
                } else {
                    sink.sendNext(result.value!)
                    sink.sendCompleted()
                }
            })
            
            disposable.addDisposable {
                
            }
        }
    }
    
}
