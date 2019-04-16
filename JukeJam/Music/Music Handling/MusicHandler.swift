import UIKit
import StoreKit

protocol MusicHandlerDelegate: class {
    func updateUI(song: Song)
    func updateState(state: SPTAppRemotePlayerState)
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
            delegate!.updateUI(song: self.currentSong!)
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
//        Need to have premium Spotify account to test this. Should test all non-premium functionality first.
//        DispatchQueue.global().async {
//            while self.spotifyFetcher.currentSong == nil{
//
//            }
//            DispatchQueue.main.async {
//                print("HERE Should update",  self.spotifyHandler.playURI)
//                self.spotifyHandler.playURI = "spotify:track:\(self.spotifyFetcher.currentSong?.id)"
//
//                self.playSong(id: (self.spotifyFetcher.currentSong?.id)!)
//            }
//        }
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

    

    
    func updateView(playerState: SPTAppRemotePlayerState) {
        //Track changed update currentSong
        if playerState.track.name != currentSong?.title{
            self.currentSong?.title = playerState.track.name
            updateCurrentSong(playerState)
            return
        }
        delegate?.updateState(state: playerState)
    }
    
    func playSong(id: String){
        if preference == Pref.spotify {
            spotifyHandler.playTrackWithIdentifier(id)
        }
        else if preference == Pref.apple {
            
        }
        else if preference == Pref.none{
            
        }
    }
    
    func updateUI(){
        if preference == Pref.spotify {
            spotifyHandler.getPlayerState()
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
    
    func updateCurrentSong(_ playerState: SPTAppRemotePlayerState) {
        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            let artist = Artist(id: playerState.track.artist.uri, name: playerState.track.artist.name)
            let album = Album(id: playerState.track.album.uri, name: playerState.track.album.name, cover: image)
            let newSong = Song(id: playerState.track.uri, title: playerState.track.name , duration: Int(playerState.track.duration), artist: [artist],  album: album)
            self.currentSong = newSong
            self.delegate?.updateState(state: playerState)
        }
    }
    
    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
       spotifyHandler.appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else {
                return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
}



