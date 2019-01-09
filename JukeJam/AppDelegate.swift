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
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    
    let SpotifyClientID = "30e40f876c2348c0bf0644d1be184864"
    let SpotifyRedirectURL = URL(string: "JukeJam://returnAfterLogin")!

    
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://juke-jam.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://juke-jam.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
  
    var window: UIWindow?

    lazy var rootViewController = SpotifyTester()

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
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
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
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScreenController") as? ScreenController
            {
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        
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
        
        self.sessionManager.application(application, open: url as URL)

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
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }
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
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("HERE init")
        self.appRemote.connectionParameters.accessToken = session.accessToken
        self.appRemote.connect()
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("HERE fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("HERE renewed", session)
    }
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("HERE CONNECTED")
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("HERE disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("HERE failed", error)
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("HERE Track name: %@", playerState.track.name)
    }


    
}

