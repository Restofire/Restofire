//
//  SessionManagable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Alamofire.Session` that is associated with `Requestable`.
public protocol SessionManagable {
    
    /// The `session`.
    var session: Session { get }
    
}

public extension SessionManagable where Self: AConfigurable {
    
    /// `AlamofireSession.default`
    public var session: Session {
        return AlamofireSession.default.session
    }
    
}
