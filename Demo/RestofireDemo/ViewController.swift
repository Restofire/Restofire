//
//  ViewController.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 10/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AppVersionGETService().executeTaskEvenually {
            print($0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

