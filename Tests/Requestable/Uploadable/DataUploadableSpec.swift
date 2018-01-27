//
//  DataUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class DataUploadableSpec: BaseSpec {
    
    struct Upload: DataUploadable {
        typealias Response = Any
        var path: String = ""
        var data: Data = Data()
    }
    
    override func spec() {
        describe("DataUpload") {
            let upload = Upload()
            
        }
    }
    
}
