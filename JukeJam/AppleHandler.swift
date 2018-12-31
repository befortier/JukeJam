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
class AppleHandler: UIViewController {

    var storeID: String = ""
    var storeFront: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//Creates a popup modal that checks to see if users want to allows Music Permission or not
  fileprivate func checkPermission(){
        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 60,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Allow") {
            self.requestMusicLibraryAccess()
            alert.hideView()
        }
        _ = alert.addButton("Not Now") {
            print("Text")
        }
     
        _ = alert.showEdit("Apple Music Permission", subTitle:"JukeJam is centered around music streaming, we would like permission to access and stream your apple music")
    }
    
   fileprivate func changePermission(){
        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 60,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Take me there") {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:]) { (Bool) -> Void
            in
                self.checkAuthorization()
                alert.hideView()
            }
        }
    _ = alert.addButton("Not Now"){
        alert.hideView()
    }
        _ = alert.showWarning("Apple Music Permission", subTitle:"JukeJam is centered around music streaming, we would like permission to access and stream your apple music")
    }
    
    
    //Checks to see what the status is: If apple music is allowed or not.
    func checkAuthorization() -> SKCloudServiceAuthorizationStatus {
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            print("The user's already authorized - we don't need to do anything more here, so we'll exit early.")
            //Continue play music?
            return .authorized
            
        case .denied:
            print("The user has selected 'Don't Allow' in the past - so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.")
            changePermission()
            return .denied
            
        case .notDetermined:
            print("The user hasn't decided yet - so we'll break out of the switch and ask them.")
            checkPermission()
            break
            
        case .restricted:
            print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            return .restricted
        }
        return SKCloudServiceController.authorizationStatus()
    }
    
//Need a preliminary function to present an alert letting people know about the importance of allowsing the game
    func requestMusicLibraryAccess()
    {
        SKCloudServiceController.requestAuthorization({
            (status: SKCloudServiceAuthorizationStatus) in
            switch(status)
            {
            case .authorized:
                break
            case .denied, .restricted:
                break
            case .notDetermined:
                break
                
            }
        })
    }
    
    // Check if the device is capable of playback
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                self.alertUser(title: "Success", message: "The user has an Apple Music subscription and can playback music!")
            } else if  capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                self.alertUser(title: "Success", message: "The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
            } else {
                self.alertUser(title: "Error", message: "The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one? \(capability)")
            }
        }
    }
    
    //UNTESTED
    func appleMusicPlayTrackId(ids:[String]) {
        let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer
        applicationMusicPlayer.setQueue(with: ids)
        applicationMusicPlayer.play()
        
    }
    

    //UNTESTED
    func playSong(){
        //Potentiall make a general Play function and then paramter of type .song, album etc.
        appleMusicFetchStorefrontRegion()
        if checkAuthorization() != .authorized {return}
        //        var url = "https://api.music.apple.com/v1/catalog/\(handler.storeID)/search?term=My+Chemical+Romance&limit=2&types=song"
        let url = "https://api.music.apple.com/v1/catalog/us/search?term=khalid"
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
    
    func appleMusicFetchStorefrontRegion() {
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier { (storefrontId:String?, err:Error?) in
            
            guard err == nil else {
                print("An error occured. Handle it here.")
                return
            }
            
            guard let storefrontId = storefrontId, storefrontId.characters.count >= 6 else {
                print("Handle the error - the callback didn't contain a valid storefrontID.")
                return
            }
            
            let str = String(storefrontId)
            self.storeID = String(str.prefix(6)) // Hello
            print("Success! The user's storefront ID is: \(self.storeID)")

            var url = "https://api.music.apple.com/v1/me/storefront"
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    //here dataResponse received from a network request
                    print(data)
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data!)
                    print("STorefront \(jsonResponse)") //Response result
                    
                } catch {
                    print("Attempt JSON Serialization error")
                }
            }).resume()

        }
    }
}
