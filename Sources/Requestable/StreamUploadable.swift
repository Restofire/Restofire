//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `StreamUploadable` for Restofire.
///
/// ### Create custom StreamUploadable
/// ```swift
/// protocol HTTPBinUploadService: StreamUploadable {
///
///     var path: String? = "post"
///     var stream: InputStream = InputStream(url: FileManager.imageURL)!
///
/// }
/// ```
public protocol StreamUploadable: AStreamUploadable, Uploadable {}
