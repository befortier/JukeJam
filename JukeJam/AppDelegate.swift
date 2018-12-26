//
//  AppDelegate.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
   


    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        checkAuth()
        return true
    }
    
    //Checks if UserDefault has any saved log in from user
    func checkAuth(){
        
        let def = UserDefaults.standard
        let is_authenticated = def.bool(forKey: "is_authenticated")
        if is_authenticated{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? HomeController
            {

                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
         
    }
    }
    
    //Deals with googleSign in, if succesful sets UserDefault info and switches page.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            let alert = UIAlertController(title: "Failed to authenticate", message: "Sorry, but we could not authenticate your google account, please try again.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        let nc = NotificationCenter.default
        nc.post(name: .startAnime, object: nil)
        print("Succesfully logged into Google", user)
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential){ (user,err) in
            if let error = err{
                let alert = UIAlertController(title: "Failed to authenticate", message: "Sorry, but we could not authenticate your firebase account, we are working to fix this.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK",
                                                 style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                return
            }
            let userID = Auth.auth().currentUser!.uid
            let def = UserDefaults.standard
            def.set(true, forKey: "is_authenticated")
            def.set(userID, forKey: "id")
            def.synchronize()
            nc.post(name: .endAnime, object: nil)
            self.checkAuth()
        }
    }
    
    //Deals with prompting users on Facebook/Google URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL?,
    sourceApplication: sourceApplication,
    annotation: annotation)
    
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL?,
    sourceApplication: sourceApplication,
    annotation: annotation)
    
    return googleDidHandle || facebookDidHandle
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

