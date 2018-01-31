//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `FileUploadable` for Restofire.
///
/// ### Create custom FileUploadable
/// ```swift
/// protocol HTTPBinUploadService: FileUploadable {
///
///     var path: String? = "post"
///     let url: URL = FileManager.url(forResource: "rainbow", withExtension: "jpg")
///
/// }
/// ```
public protocol FileUploadable: AFileUploadable, Uploadable {}
