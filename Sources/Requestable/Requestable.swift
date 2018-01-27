//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents an HTTP Request that can be asynchronously executed. You must
/// provide a `path`.
///
/// ### Creating a request.
/// ```swift
/// import Restofire
///
/// struct PersonPOSTService: RequestableBase {
///
///   let path: String
///   let method: HTTPMethod = .post
///   let parameters: Any?
///
///   init(id: String, parameters: Any? = nil) {
///     self.path = "person/\(id)"
///     self.parameters = parameters
///   }
///
/// }
/// ```
///
/// ### Consuming the request.
/// ```swift
/// import Restofire
///
/// class ViewController: UIViewController  {
///
///   var request: PersonPOSTService!
///   var person: Any!
///
///   func createPerson() {
///     request = PersonPOSTService(id: "123456789", parameters: person).executeTask()
///   }
///
///   deinit {
///     request.cancel()
///   }
///
/// }
/// ```
public protocol Requestable: RequestableBase, Validatable {
    
    /// The Alamofire validation.
    var validationBlock: DataRequest.Validation? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
}

public extension Requestable {
    
    /// `validation.validation`
    public var validationBlock: DataRequest.Validation? {
        return validation.validationBlock
    }
    
    /// `validation.acceptableStatusCodes`
    public var acceptableStatusCodes: [Int]? {
        return validation.acceptableStatusCodes
    }
    
    /// `validation.acceptableContentTypes`
    public var acceptableContentTypes: [String]? {
        return validation.acceptableContentTypes
    }
    
}

public extension Requestable {
    
    @discardableResult
    public func execute(_ completionHandler: @escaping ((DefaultDataResponse) -> Void)) -> DataRequest {
        let request = Restofire.dataRequest(fromRequestable: self)
        request.response(completionHandler: completionHandler)
        return request
    }
    
}

