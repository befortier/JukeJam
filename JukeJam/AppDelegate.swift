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
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, SPTAppRemoteDelegate {
    
    fileprivate let redirectUri = URL(string: "JukeJam://returnAfterLogin")!
    fileprivate let clientIdentifier = "30e40f876c2348c0bf0644d1be184864"
    fileprivate let name = "Now Playing View"

    // keys
    static fileprivate let kAccessTokenKey = "access-token-key"
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: AppDelegate.kAccessTokenKey)
            defaults.synchronize()
        }
    }
    
    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: self.clientIdentifier, redirectURL: self.redirectUri)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
let homeScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicPlayingController") as? MusicPlayingController

  
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        let nav = UINavigationBar.appearance()
        let font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        nav.tintColor = UIColor.white
        nav.barTintColor = UIColor.stem
        nav.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,  NSAttributedString.Key.font: font]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().barStyle = .blackOpaque
        checkAuth()
 

        return true
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
            if (homeScreen != nil)
            {
                window?.rootViewController = homeScreen
                window?.makeKeyAndVisible()
            }
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let parameters = appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
             homeScreen?.spotifyHandler.showError(error_description);
        }
        return true
    }
    //Deals with googleSign in, if succesful sets UserDefault info and switches page.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil{
            let alert = UIAlertController(title: "Failed to authenticate", message: "Sorry, but we could not authenticate your google account, please try again.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        let nc = NotificationCenter.default
        var obj: [String:Any] = [:]
        obj["name"] = user.profile.name
        obj["email"] = user.profile.email
        obj["last_name"] = user.profile.familyName
        obj["first_name"] = user.profile.givenName
        obj["imageBool"] = user.profile.hasImage
        obj["id"] = user.userID

        obj["image"] = user.profile.imageURL(withDimension: 800)
        
        nc.post(name: .startAnime, object: nil)
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
            nc.post(name: .endAnime, object: nil, userInfo: obj)
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
         homeScreen?.spotifyHandler.appRemoteDisconnect()
        appRemote.disconnect()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.connect();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func connect() {
         homeScreen?.spotifyHandler.appRemoteConnecting()
        appRemote.connect()
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
         homeScreen?.spotifyHandler.appRemoteConnected()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
         homeScreen?.spotifyHandler.appRemoteDisconnect()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
        homeScreen?.spotifyHandler.appRemoteDisconnect()
    }




    
}

