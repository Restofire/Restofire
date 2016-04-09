//
//  AnyRequestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 08/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

class AnyRequestable<Element> : Requestable {
    
    typealias Model = Element
    var path: String
    
    init<R : Requestable where R.Model == Element>(_ requestable: R) {
        self.path = requestable.path
    }

}
