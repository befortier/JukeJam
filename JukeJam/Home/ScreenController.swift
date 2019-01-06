//
//  ScreenController.swift
//  JukeJam
//
//  Created by Rena fortier on 12/30/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit


class ScreenController: UITabBarController {
    @IBOutlet weak var TabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBar()
        // Do any additional setup after loading the view.
    }

    func initBar(){
        let firstTab : UITabBarItem = self.TabBar.items![0]
        firstTab.title = "Home"
        firstTab.image = UIImage(named: "home")
        firstTab.selectedImage = UIImage(named: "home_1")
        let secondTab : UITabBarItem = self.TabBar.items![1]
        secondTab.title = "Search"
        secondTab.image = UIImage(named: "find")
        secondTab.selectedImage = UIImage(named: "find_1")
    }
    



}
