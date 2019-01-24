
import Foundation
import Alamofire
import Spartan

class MusicUIController: NSObject {
    var stateButton: UIButton!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var coverImageView: UIImageView!
    var songLabel: UILabel!
    var handler: MusicHandler!
    var playImage: UIImage = UIImage(named: "play")!
    var pauseImage: UIImage = UIImage(named: "pause")!
    var buttons: [UIButton] = []
    
    init(state: UIButton, next: UIButton, cover: UIImageView, song: UILabel, handler: MusicHandler){
        super.init()
        self.stateButton = state
        self.nextButton = next
        self.coverImageView = cover
        self.songLabel = song
        self.handler = handler
        buttons = [stateButton, nextButton]
        self.initButtons()
        handler.updateUI()
    }
    
    convenience init(state: UIButton, next: UIButton, cover: UIImageView, song: UILabel, prev: UIButton, handler: MusicHandler){
        self.init(state: state, next: next, cover: cover, song: song, handler: handler)
        self.prevButton = prev
        prevButton.layer.cornerRadius = prevButton.frame.width/2
        prevButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
        buttons.append(prevButton)
    }
    
    func initButtons(){
        stateButton.layer.cornerRadius = stateButton.frame.width/2
        stateButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
    }
    

     func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        updatePlayPauseButtonState(playerState.isPaused)
        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            let artist = Artist(id: playerState.track.artist.uri)
            artist.name = playerState.track.artist.name
            let album = Album(id: playerState.track.album.uri)
            album.name = playerState.track.album.name
            album.cover = image
            let newSong = Song(id: playerState.track.uri, title: playerState.track.name , duration: Int(playerState.track.duration), artist: [artist], cover: image, album: album)
            self.handler?.currentSong = newSong
            self.updateViewWithRestrictions(playerState.playbackRestrictions)
            
            //        updateInterfaceForPodcast(playerState: playerState)
        }
    }
    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        handler?.spotifyHandler.appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else {
                return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
    

    
     func updatePlayPauseButtonState(_ paused: Bool) {
        let playPauseButtonImage = paused ? playImage : pauseImage
        self.stateButton.setImage(playPauseButtonImage, for: UIControl.State())
        self.stateButton.setImage(playPauseButtonImage, for: .highlighted)
        self.stateButton.setNeedsDisplay()
    }
    fileprivate func updateShuffleLabel(_ isShuffling: Bool) {
        //        shuffleModeLabel.text = "Shuffle mode: " + (isShuffling ? "On" : "Off")
    }
    
    fileprivate func updateRepeatModeLabel(_ repeatMode: SPTAppRemotePlaybackOptionsRepeatMode) {
        //        repeatModeLabel.text = "Repeat mode: " + {
        //            switch repeatMode {
        //            case .off: return "Off"
        //            case .track: return "Track"
        //            case .context: return "Context"
        //            }
        //            }()
    }

  
    func updateCurrentSong(playerState: SPTAppRemotePlayerState){
        //If what is playing is not the same as the handler's current song update
        if playerState.track.name != handler.currentSong?.title{
            updateViewWithPlayerState(playerState)
        }
        //If the current musicDisplayer isnt showing the same as the handler's current song
        else {
            updateViewWithRestrictions(playerState.playbackRestrictions)
            updatePlayPauseButtonState(playerState.isPaused)
        }
    }
    
    func reset(){
        let playPauseButtonImage = playImage
        self.stateButton.setImage(playPauseButtonImage, for: UIControl.State())
        self.stateButton.setImage(playPauseButtonImage, for: .highlighted)
        coverImageView.image = UIImage(named: "No Music")
        songLabel.text = "Nothing Playing"
    }
    
    
    fileprivate func updateViewWithRestrictions(_ restrictions: SPTAppRemotePlaybackRestrictions) {
        nextButton.isEnabled = restrictions.canSkipNext

        if prevButton != nil{
            prevButton.isEnabled = restrictions.canSkipPrevious
        }
        //        toggleShuffleButton.isEnabled = restrictions.canToggleShuffle
        //        toggleRepeatModeButton.isEnabled = restrictions.canRepeatContext || restrictions.canRepeatTrack
    }
    fileprivate func updateInterfaceForPodcast(playerState: SPTAppRemotePlayerState) {
        //        skipForward15Button.isHidden = !playerState.track.isEpisode
        //        skipBackward15Button.isHidden = !playerState.track.isEpisode
        //        podcastSpeedButton.isHidden = !playerState.track.isPodcast
        //        nextButton.isHidden = !skipForward15Button.isHidden
        //        prevButton.isHidden = !skipBackward15Button.isHidden
        //        getCurrentPodcastSpeed()
    }

}
