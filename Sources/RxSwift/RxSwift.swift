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
    
    public func executeTask<Model: Any>() -> Observable<Response<Model, NSError>> {

        return Observable.create { observer in
            self.executeTask({ (response: Response<Model, NSError>) in
                if let error = response.result.error {
                    observer.on(.Error(error))
                } else {
                    observer.on(.Next(response))
                    observer.on(.Completed)
                }
            })
            
            return AnonymousDisposable {
                
            }
        }
        
    }
    
}
