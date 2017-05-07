//
//  HTTPBinConfigurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
@testable import Restofire

protocol HTTPBinConfigurable: Configurable { }

extension HTTPBinConfigurable {
    
    var configuration: Configuration {
        var config = Configuration()
        config.baseURL = "https://httpbin.org/"
        return config
    }
    
}
