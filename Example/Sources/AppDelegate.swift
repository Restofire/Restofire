//
//  AppDelegate.swift
//  Example
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit
import Restofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Restofire.Configuration.default.host = "api.github.com"
        Restofire.Retry.default.retryErrorCodes = [.notConnectedToInternet]
        
        return true
    }
    
}
