//
//  RxSwift.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire
import RxSwift

public extension RequestType {
    
    public func executeRequest() -> Observable<Model> {
        
        let request = alamofireRequest()
        let keyPath = rootKeyPath
        
        return Observable.create { observer in
        
            request.responseJSON(rootKeyPath: keyPath) { (response: Response<Model, NSError>) -> Void in
                if let error = response.result.error {
                    observer.on(.Error(error))
                } else {
                    observer.on(.Next(response.result.value!))
                    observer.on(.Completed)
                }
                if self.logging { self.logResponse(response) }
            }
            
            return AnonymousDisposable {
                request.cancel()
            }
            
        }
        
    }
    
}
