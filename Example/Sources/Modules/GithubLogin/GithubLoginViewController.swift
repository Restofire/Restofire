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

class GithubLoginViewController: ViewController {

    //Properties
    lazy var githubLoginView: GithubLoginView! = {
        let view = Bundle.main.loadNibNamed("GithubLoginView", owner: self, options: nil)?[0] as! GithubLoginView
        return view
    }()
    
    override func loadView() {
        view = githubLoginView
    }

}

// MARK :- Navigation
extension GithubLoginViewController {
    
    func performReposSegue(sender: Any? = nil) {
        performSegue(withIdentifier: "ReposSegue", sender: sender)
    }
    
}

///MARK: -
import Alamofire
import Restofire

extension GithubLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authHeader = UserDefaults.standard.value(forKey: "Authorization") as? String {
            Restofire.Configuration.default.headers["Authorization"] = authHeader
            performReposSegue()
        }
        githubLoginView.githubLoginButton.addTarget(self, action: #selector(loginWithGithub(_:)), for: .touchUpInside)
    }
    
    @objc func loginWithGithub(_ sender: AnyObject?) {
        guard let email = githubLoginView.emailTextField.text else {
            return
        }
        
        guard let password = githubLoginView.passwordTextField.text else {
            return
        }
        
        GithubLoginGETService(user: email, password: password).response()
    }
    
}
