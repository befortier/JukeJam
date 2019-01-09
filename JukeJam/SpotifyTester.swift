//
//  SpotifyTester.swift
//  JukeJam
//
//  Created by Rena fortier on 1/7/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit


class SpotifyTester: UIViewController{

    
//    let SpotifyClientID = "30e40f876c2348c0bf0644d1be184864"
//    let SpotifyRedirectURL = URL(string: "JukeJam://returnAfterLogin")!
//    let tokenSwapURL = URL(string: "http://localhost:9292/swapsf")
//    let tokenRefreshURL = URL(string: "http://localhost:9292/refreshsf")
//
//    
//    lazy var configuration = SPTConfiguration(
//        clientID: SpotifyClientID,
//        redirectURL: SpotifyRedirectURL
//    )
//    lazy var sessionManager: SPTSessionManager = {
//        if let tokenSwapURL = URL(string: "http://localhost:1234/swap"),
//            let tokenRefreshURL = URL(string: "http://localhost:1234/refresh") {
//            self.configuration.tokenSwapURL = tokenSwapURL
//            self.configuration.tokenRefreshURL = tokenRefreshURL
//            self.configuration.playURI = ""
//        }
//        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
//        return manager
//    }()
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
//        appRemote.delegate = self
//        return appRemote
//    }()
//    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
//
//
//    @IBAction func test(_ sender: Any) {
////        self.sessionManager.
////        if self.sessionManager.session != nil{
//            print("HERE is nil")
//            let requestedScopes: SPTScope = [.appRemoteControl]
//            self.sessionManager.initiateSession(with: requestedScopes, options: .default)
////        }
////        else{
////            print("HERE is not nil")
////            self.appRemote.playerAPI?.delegate = self
////            print("HERE app remote is ", self.appRemote.isConnected)
////            self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
////                if let error = error {
////                    debugPrint("HERE first error",error.localizedDescription)
////                }
////                print("HERE Success result", result)
////            })
////            print("HERE is still still not Nil")
////
////             self.appRemote.playerAPI?.play("spotify:track:13WO20hoD72L0J13WTQWlT", callback: { (result, error) in
////                 if let error = error {
////
////                     print("HERE error",error.localizedDescription)
////                 }
////                print("HERE Success?", result)
////             })
////        }
//    }
//
//
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        print("HERE FAILED :<", error)
//    }
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        print("HERE renewed", session)
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        print("HERE disconnected")
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        print("HERE better faliurE?",error)
//    }
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        debugPrint("HERE Track name: %@", playerState.track.name)
//    }
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        print("HERE working")
//        self.appRemote.connectionParameters.accessToken = session.accessToken
//        self.appRemote.connect()
//    }
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        print("HERE connected")
//        // Connection was successful, you can begin issuing commands
//        self.appRemote.playerAPI?.delegate = self
//        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//            }
//        })
//    }

}
