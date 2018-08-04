//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `MultipartUploadable` for Restofire.
///
/// ### Create custom MultipartUploadable
/// ```swift
/// protocol HTTPBinUploadService: MultipartUploadable {
///
///     var path: String? = "post"
///     var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
///         multipartFormData.append("français".data(using: .utf8)!, withName: "french")
///         multipartFormData.append("日本語".data(using: .utf8)!, withName: "japanese")
///     }
///
/// }
/// ```
public protocol MultipartUploadable: AMultipartUploadable, Uploadable {}
