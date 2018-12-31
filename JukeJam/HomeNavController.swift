//
//  HomeNavController.swift
//  JukeJam
//
//  Created by Rena fortier on 12/30/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar

class HomeNavController: MDCAppBarNavigationController, MDCAppBarNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Initialize HomeController?")
        self.title = "Home"
        initalizeHomeController()
        // Do any additional setup after loading the view.
    }
   
    func initalizeHomeController(){

        
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
