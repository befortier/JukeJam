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
    var MusicController: MusicPlayingController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBar()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func initBar(){
        UITabBar.appearance().shadowImage = nil
        TabBar.shadowImage = nil

        self.tabBarController?.tabBar.clipsToBounds = true
        let firstTab : UITabBarItem = self.TabBar.items![0]
        firstTab.title = "Home"
        firstTab.image = UIImage(named: "home")
        firstTab.selectedImage = UIImage(named: "home_filled")
        let secondTab : UITabBarItem = self.TabBar.items![1]
        secondTab.title = "Library"
        secondTab.image = UIImage(named: "music")
        secondTab.selectedImage = UIImage(named: "music_filled")
    }
    
    func test(){
//        print("HERE testing")
    }
  
   


}
