//
//  StreamUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class StreamUploadableSpec: BaseSpec {
    
    struct Upload: StreamUploadable {
        typealias Response = Any
        var path: String = ""
        var stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "jpg"))!
    }
    
    override func spec() {
        describe("StreamUpload") {
            let upload = Upload()
            
        }
    }
    
}

