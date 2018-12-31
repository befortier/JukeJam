//
//  HomeNavController.swift
//  JukeJam
//
//  Created by Rena fortier on 12/30/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar
import FontAwesome_swift

class HomeNavController: UINavigationController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        initalizeHomeController()
        // Do any additional setup after loading the view.
    }
   
    func initalizeHomeController(){
//      let attributes = [
//        NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 15, style: .solid)
//        ]
//        let button = self.navigationItem.leftBarButtonItem
//        button?.setTitleTextAttributes(attributes, for: .normal)
//        button?.title = String.fontAwesomeIcon(name: .user)
//        self.navBar.
        
     
    }
    
    @objc func test(){
        print("okay")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
