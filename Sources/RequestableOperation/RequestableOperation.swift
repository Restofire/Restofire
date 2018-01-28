//
//  RequestableOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

class RequestableOperation {
    
    let requestable: Requestable
    var request: DataRequest!
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func start(response: ((DefaultDataResponse) -> Void)? = nil) {
        request = requestable.request()
        requestable.didStart(request: request)
        request.response { [weak self] resp in
            guard let _self = self else { return }
            response?(resp)
            _self.requestable.didComplete(request: _self.request, with: resp)
        }
    }
    
}
