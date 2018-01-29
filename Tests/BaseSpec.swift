//
//  BaseSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class BaseSpec: QuickSpec {
    
    let timeout: TimeInterval = 30
    let pollInterval: TimeInterval = 1

    static var testDirectoryURL: URL { return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("org.restofire.tests") }
    var testDirectoryURL: URL { return BaseSpec.testDirectoryURL }
    
    static var jsonFileURL: URL { return testDirectoryURL.appendingPathComponent("\(UUID().uuidString).json") }
    var jsonFileURL: URL { return BaseSpec.jsonFileURL }
    
    override func spec() {
        
        beforeSuite {
            self.removeAllItemsInsideDirectory(at: self.testDirectoryURL)
            self.createDirectory(at: self.testDirectoryURL)
            
            Configuration.default.scheme = "https://"
            Configuration.default.baseURL = "httpbin.org"
        }
        
    }
    
    static func url(forResource fileName: String, withExtension ext: String) -> URL {
        return Bundle(for: BaseSpec.self).url(forResource: fileName, withExtension: ext)!
    }
    
}

extension BaseSpec {
    
    @discardableResult
    func createDirectory(at url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func removeAllItemsInsideDirectory(at url: URL) -> Bool {
        let enumerator = FileManager.default.enumerator(atPath: url.path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let success = removeItem(atPath: url.path + "/\(fileName)")
            if !success { result = false }
        }
        
        return result
    }
    
    @discardableResult
    func removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
}
