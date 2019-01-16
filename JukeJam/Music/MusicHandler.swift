import UIKit
import StoreKit

class MusicHandler: NSObject {
    var preference: Pref!
    var musicBar: MusicBar = MusicBar()
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
    var currentSong: Song?{
        didSet{
            musicBar.currentSong = self.currentSong
        }
    }
    enum Pref {
    case apple
    case spotify
    case none

    }

    override init(){
        super.init()
        appleHandler = AppleHandler()
        spotifyHandler = SpotifyHandler(playButton: musicBar.state, cover: musicBar.cover, label: musicBar.song, nextSong: musicBar.nextSong)
        initalizePreference()
        currentSong = Song(title: "Started From the Bottom Now Were Here", duration: 100, artist: "Drake", cover: UIImage(named: "album3")!)
        musicBar.currentSong = self.currentSong
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
        self.musicBar.frame = CGRect(x: -2, y: frame.frame.height - 115, width: frame.frame.width + 4, height: 68)
        print(musicBar)
        return musicBar
    }
}


