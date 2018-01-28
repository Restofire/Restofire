//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol Downloadable: ADownloadable, Configurable {
    
    func didStart(request: DownloadRequest)
    
    func didComplete(request: DownloadRequest, with: DefaultDownloadResponse)
}

public extension Downloadable {
    
    /// `Does Nothing`
    func didStart(request: DownloadRequest) {}
    
    /// `Does Nothing`
    func didComplete(request: DownloadRequest, with: DefaultDownloadResponse) {}
    
}
