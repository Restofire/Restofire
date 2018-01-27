//
//  DownloadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class DownloadableSpec: BaseSpec {
    
    struct Download: Downloadable {
        typealias Response = Any
        var baseURL: String = "upload.wikimedia.org"
        var path: String = "wikipedia/commons/6/69/NASA-HS201427a-HubbleUltraDeepField2014-20140603.jpg"
    }
    
    override func spec() {
        describe("Download") {
            let download = Download()
            
        }
    }
    
}
