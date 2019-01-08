//
//  AppleHandler.swift
//  JukeJam
//
//  Created by Rena fortier on 12/29/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import Foundation
import StoreKit
import MediaPlayer
import SCLAlertView
class SpotifyHandler: UIViewController,  SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
 
    
    var storeID: String = ""
    var storeFront: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
            self.configuration.playURI = "spotify:track:20I6sIOMTCkB6w7ryavxtO"
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    func didTapConnect() {
        /*
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        
        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        }
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        <#code#>
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        <#code#>
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        <#code#>
    }
    
}
