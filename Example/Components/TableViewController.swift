//
//  TableViewController.swift
//  iWork
//
//  Created by Rahul Katariya on 08/06/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var topView: UIView!
    var _seperatorStyle: UITableViewCellSeparatorStyle!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView?.frame = view.bounds
    }
    
    func showTopView(_ topView: UIView) {
        hideTopView()
        self.topView = topView
        view.addSubview(topView)
        view.setNeedsLayout()
        _seperatorStyle = tableView.separatorStyle;
        tableView.separatorStyle = .none
    }
    
    func hideTopView() {
        if let _ = self.topView {
            topView.removeFromSuperview()
            topView = nil
            tableView.separatorStyle = _seperatorStyle
        }
    }
    
}
