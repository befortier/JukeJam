
import Foundation
class MusicUIController: NSObject {
    var stateButton: UIButton!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var coverImageView: UIImageView!
    var songLabel: UILabel!
    var handler: MusicHandler!
    var playImage: UIImage = UIImage(named: "play")!
    var pauseImage: UIImage = UIImage(named: "pause")!
    
    init(state: UIButton, next: UIButton, cover: UIImageView, song: UILabel, handler: MusicHandler){
        super.init()
        self.stateButton = state
        self.nextButton = next
        self.coverImageView = cover
        self.songLabel = song
        self.handler = handler
        self.initButtons()
    }
    
    func initButtons(){
        stateButton.setImage(playImage, for: UIControl.State.normal)
        stateButton.setImage(playImage, for: UIControl.State.highlighted)
//        nextButton.setImage(pauseImage, for: UIControl.State.normal)
//        nextButton.setImage(pauseImage, for: UIControl.State.highlighted)
        stateButton.showsTouchWhenHighlighted = true
        stateButton.layer.cornerRadius = stateButton.frame.width/2
        stateButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
        nextButton.showsTouchWhenHighlighted = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
    }
    
     func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        updatePlayPauseButtonState(playerState.isPaused)
        //        updateRepeatModeLabel(playerState.playbackOptions.repeatMode)
        //        updateShuffleLabel(playerState.playbackOptions.isShuffling)
//        self.songLabel.text = handler.currentSong?.title
        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            let newSong = Song(title: playerState.track.name , duration: TimeInterval(playerState.track.duration), artist: playerState.track.artist.name, cover: image, album: playerState.track.album.name)
            self.updateAlbumArtWithImage(image)
            self.handler?.currentSong = newSong
            self.fillInfo(song: newSong)
            
            //        updateViewWithRestrictions(playerState.playbackRestrictions)
            //        updateInterfaceForPodcast(playerState: playerState)
        }
    }
    fileprivate func fillInfo(song: Song){
        songLabel.text = song.title
        coverImageView.image = song.cover
    }
    
    fileprivate func updatePlayPauseButtonState(_ paused: Bool) {
        let playPauseButtonImage = paused ? playImage : pauseImage
        self.stateButton.setImage(playPauseButtonImage, for: UIControl.State())
        self.stateButton.setImage(playPauseButtonImage, for: .highlighted)
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
    fileprivate func updateAlbumArtWithImage(_ image: UIImage) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        self.coverImageView.layer.add(transition, forKey: "transition")
    }
    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        handler?.spotifyHandler.appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else { return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
    
    func updateCurrentSong(playerState: SPTAppRemotePlayerState){
        
        //If what is playing is not the same as the handler's current song update
        if playerState.track.name != handler.currentSong?.title{
            updateViewWithPlayerState(playerState)
        }
        //If the current musicDisplayer isnt showing the same as the handler's current song
        else if handler.currentSong?.title != songLabel.text{
            fillInfo(song: handler.currentSong!)
        }
        //
        else{
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
//        nextSong.isEnabled = restrictions.canSkipNext
        //        prevButton.isEnabled = restrictions.canSkipPrevious
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
