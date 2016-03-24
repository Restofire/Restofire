//
//  Configuration.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import enum Alamofire.ParameterEncoding

public class Configuration {
    
    public static let defaultConfiguration = Configuration()
    
    public var logging: Bool = false
    public var baseURL: String!
    public var encoding: Alamofire.ParameterEncoding = .JSON
    public var headers: [String : String]?
    
}