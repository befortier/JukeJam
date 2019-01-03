//
//  FbLoginHandler.swift
//  JukeJam
//
//  Created by Rena fortier on 12/27/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import SkyFloatingLabelTextField

extension ViewController{
    
   //Handles preliary FB login methods. 
    func loginFB(){
         var _fbLoginManager: LoginManager?
        
        var fbLoginManager: LoginManager {
            get {
                if _fbLoginManager == nil {
                    _fbLoginManager = LoginManager()
                }
                return _fbLoginManager!
            }
        }
        let loginManager = fbLoginManager
        loginManager.logIn(readPermissions: [.publicProfile,.email, .userBirthday, .userGender, .userLocation], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.startAnimate(wholeView: self.wholeView, frame: self, message: "Loading your Account")
                self.signIntoFirebase()
                break
                
            case .failed(let error):
                self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your facebook account, please try again.")
                print("Login FB Error: \(error)")

                
                break
                
            case .cancelled:
                // self.alertUser(title: "Cancelled authentication", message: "It appears you cancelled your Facebook authentication.")
                break
            }
        }
    }
    
    //Signs into Firebase
    fileprivate func signIntoFirebase(){
        guard let accessTokenString = FBSDKAccessToken.current()?.tokenString else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credential){ (user,err) in
            if err != nil{
                self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your account in our database, we are working to fix this")
                print("Login Error: \(err)")
                return
            }
            self.fillFBProfile()
            self.endAnimate(wholeView: self.wholeView, frame: self)
        }
        
    }
    

// Iterates through params and gets params from FB Db about user info. When it gets al of them, it calls fillUserData with a dictionary of values
   fileprivate func fillFBProfile(){
        let semaphore = DispatchSemaphore(value: 1)
        var temp: [String:Any] = [:]
        var counter: Int = 0
        let length = 8
        let params = ["name","first_name","last_name","location","gender","birthday","email", "id"]
        let handler: ([String:AnyObject], String?) -> Void = { data, field in
            semaphore.wait()
            if field == "id"{
                temp["F_id"] = (data[field!])!
            }
            else{
                temp[field!] = data[field!]
                if field == "location"{
                    temp[field!] = (data["location"]?["name"])!
                }
            }
            counter += 1
            if counter == length{
                self.fillUserData(Dict: temp)
            }
            semaphore.signal()
        }
        for i in 0..<length {
            self.fetchFBInfo(field: params[i], dict: temp, completionHandler: handler)
        }
    }

// Fetches user info from FB db
  fileprivate func fetchFBInfo(field: String, dict: [String: Any], completionHandler: @escaping ([String:AnyObject], String?) -> Void)
    {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields": field]).start {connection,result,error in
            
            if error != nil
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                completionHandler(data, field)
            }
        }
    }
    

}
