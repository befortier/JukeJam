import UIKit
import StoreKit

class MusicHandler: NSObject {
    
    var spotifyHandler: SpotifyHandler! {
        didSet {
            checkPreference()
        }
    }
    var appleHandler: AppleHandler! {
        didSet {
            checkPreference()
        }
    }
    enum Pref {
    case apple
    case spotify
    case none

    }
    var preference: Pref!

     init(playButton: UIButton, cover: UIImageView, label: UILabel, nextSong: UIButton){
        super.init()
        spotifyHandler = SpotifyHandler(playButton: playButton, cover: cover, label: label, nextSong: nextSong)
        print("HERE MusicHandler spothandler:", playButton)
        spotifyHandler.playPauseButton.tintColor = UIColor.red
        appleHandler = AppleHandler()
        initalizePreference()
    }
    convenience override init(){
        self.init(playButton: UIButton(), cover: UIImageView(), label: UILabel(), nextSong: UIButton())
    }
    
     
    //Should set gloabl preference variable to be apple if apple is available + has playback, spotify if apple doesnt have playback, apple if both dont have playback, spotify if doesnt have apple, none if has neither.
    func initalizePreference(){
        preference = Pref.spotify
        
    }
    //Should recheck apple and spotify playback capabilities if they are changed mid app for some reason, and update preference otherwise
    func checkPreference(){
        
    }
    
    //Checks to see which is the current used preference system and calls Spotify.play/ Apple.play
    func PlayPauseMusic(){
        if preference == Pref.spotify {
            
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func nextSong(){
        if preference == Pref.spotify {
            
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func prevSong(){
        if preference == Pref.spotify {
            
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func endSession(){
        spotifyHandler.terminate()
    }
    
    
}


