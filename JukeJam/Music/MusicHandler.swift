import UIKit
import StoreKit

protocol MusicHandlerDelegate: class {
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState)
}

class MusicHandler: NSObject, SpotifyHandlerDelegate {
   
    
    var preference: Pref!
    weak var delegate: MusicHandlerDelegate?

    var musicBar: MusicBar!
    var spotifyHandler: SpotifyHandler! {
        didSet {
            spotifyHandler.delegate = self
            checkPreference()
        }
    }
    var appleHandler: AppleHandler! {
        didSet {
            checkPreference()
        }
    }
    var spotifyFetcher: SpotifyFetcher!

    var currentSong: Song?{
        didSet{
            self.updateUI()
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
        spotifyFetcher = SpotifyFetcher()
        spotifyHandler = SpotifyHandler()
        musicBar = MusicBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0), handler: self)
        self.delegate = musicBar
        musicBar.musicHandler = self
        initalizePreference()
    }
    
    func terminate(){
        if preference == Pref.spotify {
            spotifyHandler.terminate()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
        musicBar.reset()
    }
    
    func resetUponArrival(){
        if preference == Pref.spotify {
            spotifyHandler = SpotifyHandler()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
        updateUI()
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
            spotifyHandler.didPressPlayPauseButton()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func nextSong(){
        if preference == Pref.spotify {
            spotifyHandler.didPressNextButton()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func prevSong(){
        if preference == Pref.spotify {
            spotifyHandler.didPressPreviousButton()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
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
        return musicBar
    }
    
    func updateView(playerState: SPTAppRemotePlayerState) {
        delegate!.updateViewWithPlayerState(playerState)
        musicBar!.updateViewWithPlayerState(playerState)

    }
    
    func updateUI(){
        if preference == Pref.spotify {
            spotifyHandler.getPlayerState()
//            loadUser()
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func getUserID() -> String{
        if preference == Pref.spotify {
//           return spotifyHandler.appRemote.us
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
        return "false"
    }
    
    func loadUser() {
        if preference == Pref.spotify {           
            
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
       
    }

}



