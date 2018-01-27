//
//  FileUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class FileUploadableSpec: BaseSpec {
    
    struct Upload: FileUploadable {
        typealias Response = Any
        var path: String = ""
        var url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "jpg")
    }
    
    override func spec() {
        describe("FileUpload") {
            let upload = Upload()
            
        }
    }
    
}

