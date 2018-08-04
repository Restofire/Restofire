//
//  DataUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `DataUploadable` for Restofire.
///
/// ### Create custom DataUploadable
/// ```swift
/// protocol HTTPBinUploadService: DataUploadable {
///
///     var path: String? = "post"
///     var data: Data = {
///         return "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
///            .data(using: .utf8, allowLossyConversion: false)!
///     }()
///
/// }
/// ```
public protocol DataUploadable: ADataUploadable, Uploadable  {}
