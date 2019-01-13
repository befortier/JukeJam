//
//  ControllerController.swift
//  JukeJam
//
//  Created by Rena fortier on 1/13/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import NVActivityIndicatorView

class ControllerController: UIViewController {
    var LoginController: ViewController!
    var AppController: MusicPlayingController!
    var ConfirmController: ConfirmController!
    var musicHandler: MusicHandler!
    enum controllerType {
        case login
        case app
        case newUser
    }
    
    @IBAction func test(_ sender: Any) {
        if let controller = curController() {
            print("HERE good")
            self.present(controller, animated: true, completion: nil)
        }
    }
    var state: controllerType = controllerType.login
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeControllers()
        checkAuth()
        musicHandler = MusicHandler()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
            self.presentController(sender:self)
        }
    }
    func presentController(sender: UIViewController){
        if let controller = curController() {
            sender.dismiss(animated: true)
            sender.present(controller, animated: true, completion: nil)
        }
        else{
            //CHANGE TO BUG CONTROLLER OR SOMETHING
            sender.present(AppController, animated: true, completion: nil)
        }
    }
    func initializeControllers(){
        
        LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? ViewController
        AppController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicPlayingController") as? MusicPlayingController
        ConfirmController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmController") as? ConfirmController
        
        AppController.mainController = self
        AppController.musicHandler = self.musicHandler
        LoginController.mainController = self
        ConfirmController.mainController = self
    }
    func initliazeConstants(){
        
    }
    func curController() -> UIViewController?{
        initializeControllers()
        if state == .login{
            return LoginController!
        }
        else if state == .app {
            return AppController!
        }
        else if state == .newUser{
            return ConfirmController!
        }
        return LoginController!
    }
    
    //Checks if UserDefault has any saved log in from user
    func checkAuth(){
        let is_authenticated = Auth.auth().currentUser
        let def = UserDefaults.standard
        var curUser: User?
        let userData = def.object(forKey: "user") as? NSData
        if let user = userData {
            curUser = (NSKeyedUnarchiver.unarchiveObject(with: user as Data) as? User)!
        }
        if is_authenticated != nil && curUser != nil{
            if (AppController != nil)
            {
                state = .app
            }
            else {
                //LOGOUT
            }
        }
    }
}
