//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol Configurable {
    
    /// The Restofire configuration. `Restofire.defaultConfiguration` by default.
    var configuration: Configuration { get }

}

public extension Configurable {
    
    public var configuration: Configuration {
        get { return Restofire.defaultConfiguration }
    }
    
}