//
//  FbLoginHandler.swift
//  JukeJam
//
//  Created by Rena fortier on 12/27/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import SkyFloatingLabelTextField

extension ViewController{
    
   //Handles preliary FB login methods. 
    func loginFB(){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email, .userBirthday, .userGender, .userLocation], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.startAnimate(wholeView: self.wholeView, frame: self, message: "Loading your Account")
                self.signIntoFirebase()
                break
                
            case .failed( _):
                self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your facebook account, please try again.")
                break
                
            case .cancelled:
                // self.alertUser(title: "Cancelled authentication", message: "It appears you cancelled your Facebook authentication.")
                break
            }
        }
    }
    
    //Signs into Firebase
    fileprivate func signIntoFirebase(){
        guard let accessTokenString = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credential){ (user,err) in
            if err != nil{
                self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your account in our database, we are working to fix this")
                
                return
            }
            self.fillFBProfile()
            self.saveLoggedState()
            self.endAnimate(wholeView: self.wholeView, frame: self)
            self.switchControllers()
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
    
//    Takes in a Dict and creates a UserDefault user, calls saveDatabase(dict)
    func fillUserData(Dict: [String:Any]){
        let user: User = User(name: Dict["name"] as! String)
        user.location = Dict["location"] as? String
        user.birthday = Dict["birthday"] as? String
        user.email = Dict["email"] as? String
        user.first_name = Dict["first_name"] as? String
        user.last_name = Dict["last_name"] as? String
        user.gender = Dict["gender"] as? String
        user.F_id = Dict["F_id"] as? String
        user.G_id = Dict["G_id"] as? String
        user.username = Dict["username"] as? String
        let userData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(userData, forKey: "user")
        self.saveDatabase(Data: Dict)
    }
}
