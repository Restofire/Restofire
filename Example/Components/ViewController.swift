//
//  ViewController.swift
//  iWork
//
//  Created by Rahul Katariya on 07/06/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var topView: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView?.frame = view.bounds
    }
    
    func showTopView(_ topView: UIView) {
        self.topView = topView
        view.addSubview(topView)
        view.setNeedsLayout()
    }
    
    func hideTopView() {
        topView.removeFromSuperview()
        topView = nil
    }

}
