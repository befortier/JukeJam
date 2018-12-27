//
//  HomeController.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FacebookLogin

class HomeController: UIViewController {

    @IBOutlet weak var temp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let def = UserDefaults.standard
        let userID = def.string(forKey: "id")
        self.navigationItem.title = "Home"
        loadInfo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Logs people out of their account
    @IBAction func logOut(_ sender: UIButton) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        do {
            try Auth.auth().signOut()
            AccessToken.refreshCurrentToken()
            let def = UserDefaults.standard
            def.set(false, forKey: "is_authenticated")
            def.set(nil, forKey: "id")
            def.synchronize()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? ViewController
            {
                present(vc, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
