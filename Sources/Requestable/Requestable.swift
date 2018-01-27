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
public protocol Requestable: RequestableBase {
    
    /// The Alamofire data request validation.
    var validationBlock: DataRequest.Validation? { get }
    
}

public extension Requestable {
    
    /// `configuration.dataValidation`
    public var validationBlock: DataRequest.Validation? {
        return configuration.dataValidation
    }
    
}

public extension Requestable {

    public func request() -> DataRequest {
        return RestofireRequest.dataRequest(fromRequestable: self)
    }
    
}
