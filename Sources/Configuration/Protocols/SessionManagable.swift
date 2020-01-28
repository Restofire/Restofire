//
//  SessionManagable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.Session` that is associated with `Requestable`.
public protocol SessionManagable {
    /// The `session`.
    var session: Session { get }
}

extension SessionManagable where Self: Configurable {
    /// `Session.default`
    public var session: Session {
        return SessionManager.default.session
    }
}
