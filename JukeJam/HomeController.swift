//
//  HomeController.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import MediaPlayer
import FirebaseAuth
import SCLAlertView

class HomeController: UIViewController {

    @IBOutlet weak var testing: UIButton!
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
    @IBAction func testFunc(_ sender: UIButton) {
        let handler: AppleHandler = AppleHandler()
        //Checks to see if User has authorized
        //Put below in AppleHandler.play([ID]'s) function
        handler.appleMusicFetchStorefrontRegion()
        if handler.checkAuthorization() != .authorized {return}
     

//        var url = "https://api.music.apple.com/v1/catalog/\(handler.storeID)/search?term=My+Chemical+Romance&limit=2&types=song"
        var url = "https://api.music.apple.com/v1/catalog/us/search?term=khalid"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                //here dataResponse received from a network request
                print(data!)
                print(response!)

                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data!, options: [])
                print(jsonResponse) //Response result
//                self.appleMusicPlayTrackId(ids: )

            } catch {
                print("JSON Serialization error")
            }
        }).resume()

    }
    
    func appleMusicPlayTrackId(ids:[String]) {
    let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer
    applicationMusicPlayer.setQueue(with: ids)
    applicationMusicPlayer.play()
    
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
