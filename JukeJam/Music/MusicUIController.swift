
import Foundation
import Alamofire

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
        print("HERE 1 ")
        updatePlayPauseButtonState(playerState.isPaused)
        print("HERE 1b ", playerState.track)

        //        updateRepeatModeLabel(playerState.playbackOptions.repeatMode)
        //        updateShuffleLabel(playerState.playbackOptions.isShuffling)
        
//        Alamofire.request()
//        let id = playerState.track.album
//        AF.request("https://api.spotify.com/v1/albums/\(id)").response {
//            (request, response, data, error) -> Void in
//
//            let json = JSONValue(data as? NSData)
//            let jsonString = json.rawJSONString
//            print(jsonString)
//
//        }
      


        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            print("HERE 1c ")
            let newSong = Song(title: playerState.track.name , duration: TimeInterval(playerState.track.duration), artist: playerState.track.artist.name, cover: image, album: playerState.track.album.name)
            self.handler?.currentSong = newSong
            print("HERE handler is", self.handler)
            self.updateAlbumArtWithImage(image)
            self.fillInfo(song: newSong)
            self.updateViewWithRestrictions(playerState.playbackRestrictions)
            
            //        updateInterfaceForPodcast(playerState: playerState)
        }
    }
    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        print("HERE 1abc")
        handler?.spotifyHandler.appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else {
                print ("HERE ERROR")
                return }
            
            let image = image as! UIImage
            print("HERE SUCCESS")
            callback(image)
        })
    }
    
    fileprivate func fillInfo(song: Song){
        songLabel.text = song.title
        coverImageView.image = song.cover
    }
    
    fileprivate func updatePlayPauseButtonState(_ paused: Bool) {
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
    fileprivate func updateAlbumArtWithImage(_ image: UIImage) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        self.coverImageView.layer.add(transition, forKey: "transition")
    }
  
    func updateCurrentSong(playerState: SPTAppRemotePlayerState){
        //If what is playing is not the same as the handler's current song update
        if playerState.track.name != handler.currentSong?.title{
            updateViewWithPlayerState(playerState)
        }
        //If the current musicDisplayer isnt showing the same as the handler's current song
        else if handler.currentSong?.title != songLabel.text{
            print("HERE 2")
            fillInfo(song: handler.currentSong!)
            updateViewWithRestrictions(playerState.playbackRestrictions)
            updatePlayPauseButtonState(playerState.isPaused)
        }
        else{
            print("HERE 3")
            updatePlayPauseButtonState(playerState.isPaused)
        }
    }
    
    func reset(){
        let playPauseButtonImage = playImage
        self.stateButton.setImage(playPauseButtonImage, for: UIControl.State())
        self.stateButton.setImage(playPauseButtonImage, for: .highlighted)
        coverImageView.image = UIImage(named: "No Music")
        songLabel.text = "Nothing Playing"
        enableInterface(false)
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
    fileprivate func enableInterface(_ enabled: Bool = true) {
//                buttons.forEach { (button) -> () in
//                    button.isEnabled = enabled
//                    button.setNeedsLayout()
//                    button.setNeedsDisplay()
//                }
//                if (!enabled) {
//                    updatePlayPauseButtonState(true);
//                }
    }
}
