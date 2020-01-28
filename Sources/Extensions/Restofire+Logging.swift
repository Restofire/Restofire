//
//  Restofire+RequestLogging.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    func logRequestIfNeeded() {
        if let argumentIndex = ProcessInfo.processInfo.arguments
            .firstIndex(of: "-org.restofire.Restofire.Debug") {
            underlyingQueue.sync { [unowned self] in
                let logLevel = ProcessInfo.processInfo.arguments[argumentIndex + 1]
                if logLevel == "1" {
                    print("/**************************************** Request ****************************************/")
                    print(self.cURLDescription())
                    print("/**************************************** RequestEnd ****************************************/")
                }
            }
        }
    }

    func logDataRequestIfNeeded(result: DataResponse<Data?>) {
        if let argumentIndex = ProcessInfo.processInfo.arguments
            .firstIndex(of: "-org.restofire.Restofire.Debug") {
            underlyingQueue.sync { [unowned self] in
                let logLevel = ProcessInfo.processInfo.arguments[argumentIndex + 1]
                if logLevel == "2" {
                    print("/**************************************** Response ****************************************/")
                    print(self.response.debugDescription)
                    print("/**************************************** ResponseEnd ****************************************/")
                } else if logLevel == "3" {
                    print("/**************************************** Request ****************************************/")
                    print(self.cURLDescription())
                    print("/**************************************** RequestEnd ****************************************/")
                    print("")
                    print("/**************************************** Response ****************************************/")
                    print(self.response.debugDescription)
                    print("/**************************************** ResponseEnd ****************************************/")
                    let value = String(data: result.data ?? Data(), encoding: .utf8)
                    print("")
                    print("/**************************************** Result ****************************************/")
                    print(value ?? result.error.debugDescription)
                    print("/**************************************** ResultEnd ****************************************/")
                }
            }
        }
    }

    func logDownloadRequestIfNeeded(result: DownloadResponse<URL?>) {
        if let argumentIndex = ProcessInfo.processInfo.arguments
            .firstIndex(of: "-org.restofire.Restofire.Debug") {
            underlyingQueue.sync { [unowned self] in
                let logLevel = ProcessInfo.processInfo.arguments[argumentIndex + 1]
                if logLevel == "2" {
                    print("/**************************************** Response ****************************************/")
                    print(self.response.debugDescription)
                    print("/**************************************** ResponseEnd ****************************************/")
                } else if logLevel == "3" {
                    print("/**************************************** Request ****************************************/")
                    print(self.cURLDescription())
                    print("/**************************************** RequestEnd ****************************************/")
                    print("/**************************************** Response ****************************************/")
                    print(self.response.debugDescription)
                    print("/**************************************** ResponseEnd ****************************************/")
                    print("/**************************************** Result ****************************************/")
                    print(result.fileURL ?? result.error.debugDescription)
                    print("/**************************************** ResultEnd ****************************************/")
                }
            }
        }
    }
}
