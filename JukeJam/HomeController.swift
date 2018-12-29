//
//  HomeController.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import FBSDKLoginKit
//import FacebookCore
import FacebookLogin
import StoreKit
import MediaPlayer
import FirebaseAuth

class HomeController: UIViewController, MPMediaPickerControllerDelegate {

    @IBOutlet weak var testing: UIButton!
    @IBOutlet weak var temp: UILabel!
    var myMediaPlayer = MPMusicPlayerController.systemMusicPlayer

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
    @IBAction func testFunc(_ sender: UIButton) {
        appleMusicCheckIfDeviceCanPlayback()
        let myMediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
        myMediaPickerVC.allowsPickingMultipleItems = true
        myMediaPickerVC.popoverPresentationController?.sourceView = sender
        myMediaPickerVC.delegate = self
        self.present(myMediaPickerVC, animated: true, completion: nil)
    }
    // Check if the device is capable of playback
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            
            switch capability {
                
            case []:

                self.alertUser(title: "Error", message: "The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
                
            case SKCloudServiceCapability.musicCatalogPlayback:
                
                print("The user has an Apple Music subscription and can playback music!")
                
            case SKCloudServiceCapability.addToCloudMusicLibrary:
                
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
                
            default:
                print("Defualt")
                break
                
            }
        }
    }
    //Logs people out of their account
    @IBAction func logOut(_ sender: UIButton) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        do {
            try Auth.auth().signOut()
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
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
