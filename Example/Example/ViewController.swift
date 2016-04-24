//
//  ViewController.swift
//  Example
//
//  Created by Rahul Katariya on 17/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit
import Foundation
import Restofire
import Alamofire

struct StringGETService: Requestable {

    typealias Model = Int
    let path: String = "56c2bcde120000022473f19b"
    
    func didSucceedWithModel(model: Model) {
        print(model)
    }
    
    func didFailWithError(error: NSError) {
        print(error)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StringGETService().executeTask() {
            print($0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
