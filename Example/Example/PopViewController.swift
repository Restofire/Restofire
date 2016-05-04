//
//  PopViewController.swift
//  Example
//
//  Created by Rahul Katariya on 28/04/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit
import Restofire

class PopViewController: UIViewController {

    let service = PersonGETService()
    var requestOperation: RequestOperation<PersonGETService>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestOperation = service.requestOperation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func popButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
        requestOperation.start()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        // requestOperation.cancel()
    }

}
