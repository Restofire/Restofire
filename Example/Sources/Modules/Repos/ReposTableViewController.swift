//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2016 RahulKatariya. All rights reserved.
//

import UIKit
import Restofire

class ReposTableViewController: TableViewController {

    lazy var reposLoadingView: UIView! = {
        let view = Bundle.main.loadNibNamed("ReposLoadingView", owner: self, options: nil)?[0] as! UIView
        return view
    }()

    lazy var reposTableView: ReposTableView! = {
        let view = Bundle.main.loadNibNamed("ReposTableView", owner: self, options: nil)?[0] as! ReposTableView
        return view
    }()
    
    lazy var reposRetryView: ReposRetryView! = {
        let view = Bundle.main.loadNibNamed("ReposRetryView", owner: self, options: nil)?[0] as! ReposRetryView
        view.retryButton.addTarget(self, action: #selector(loadData(_:)), for: .touchUpInside)
        return view
    }()
    
    override func loadView() {
        view = reposTableView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reposLoadingView.frame = view.bounds
    }

}

///MARK: -
import Restofire
import Alamofire

extension ReposTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @objc func loadData(_ sender: AnyObject? = nil) {
        showTopView(reposLoadingView)
        ReposGETService().executeTask { [weak self] in
            guard let _self = self else { return }
            if let _ = $0.result.error {
                _self.showTopView(_self.reposRetryView)
            } else {
                _self.reposTableView.repos = $0.result.value
                _self.reposTableView.reloadData()
                _self.hideTopView()
            }
        }
    }
    
}
