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
    var musicBar: MusicBar!
    override init(){
        super.init()
        musicBar = MusicBar()
//        self.musicBar.songText = "Started From the Bottom Now We're Here"
//        self.musicBar.coverImage = UIImage(named: "album2")
        spotifyHandler = SpotifyHandler(playButton: musicBar.state, cover: musicBar.cover, label: musicBar.song, nextSong: musicBar.nextSong)
        appleHandler = AppleHandler()
        initalizePreference()
        
    }
//    convenience override init(){
//        self.init(playButton: UIButton(), cover: UIImageView(), label: UILabel(), nextSong: UIButton())
//    }
    
     
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
    
    func addBar(frame: UIView) -> MusicBar{
        frame.addSubview(musicBar)
        NSLayoutConstraint.activate([
            musicBar.topAnchor.constraint(equalTo: frame.topAnchor),
            musicBar.bottomAnchor.constraint(equalTo: frame.bottomAnchor),
            musicBar.leadingAnchor.constraint(equalTo: frame.leadingAnchor),
            musicBar.trailingAnchor.constraint(equalTo: frame.trailingAnchor),
            ])
        self.musicBar.frame = CGRect(x: -2, y: frame.frame.height - 115, width: frame.frame.width + 4, height: 66)
        print(musicBar)
        return musicBar
    }
}


