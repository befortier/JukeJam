//
//  MusicBar.swift
//  JukeJam
//
//  Created by Rena fortier on 1/10/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol MusicBarDelegate: class {
    func expandSong(song: Song)
}

class MusicBar: UIView, SongSubscriber {
    weak var delegate: MusicBarDelegate?
    var MusicHandler: MusicHandler?
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var cover: UIImageView! {
        didSet{
            if currentSong != nil{
                configure(song: self.currentSong)

            }
        }
    }
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var state: UIButton!
    var coverImage: UIImage?
    var songText: String?
    var currentSong: Song? {
        didSet{
           wrapperCaller()
        }
    }
  
    func wrapperCaller(){
        if cover != nil && song != nil{
            configure(song: self.currentSong)
        }
    }
    override init(frame: CGRect){
        super.init(frame:frame)
        overAllInit()


    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        overAllInit()
    }
    
    func overAllInit(){
        commonInit()
        setupView()
        initSongController()
        configure(song: currentSong)
        initButtons()
    }
    
    private func initSongController(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSongController))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func showSongController(){
        print(currentSong)
        guard let song = currentSong else {
            print("HERE ERROR")
            return
        }
        
        delegate?.expandSong(song: song)
        
        
    }
    
    @IBAction func stateChange(_ sender: Any) {
        MusicHandler?.PlayPauseMusic()
    }
    
    @IBAction func nextSong(_ sender: Any) {
        MusicHandler?.nextSong()
    }
    
    private func updateInfo(){
        
        
    }
    private func setupView() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.75)
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.45
        self.cover.layer.cornerRadius = 8.0
        self.cover.clipsToBounds = true
    }
    
    private func commonInit(){
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
}
// MARK: - Internal
extension MusicBar {
    
    func configure(song: Song?) {
        if let song = song {
//                self.song.text = song.title
                //            song.loadSongImage { [weak self] image in
//                self.cover.image = song.cover
            
            //Also need to update MaxiDelegate controls
        }
    }
}



extension MusicBar: SpotifyHandlerDelegate {
    func updateView(playerState: SPTAppRemotePlayerState) {
        updateViewWithPlayerState(playerState)
        
    }
}

extension MusicBar{
    fileprivate func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        print("HERE")
        updatePlayPauseButtonState(playerState.isPaused)
        //        updateRepeatModeLabel(playerState.playbackOptions.repeatMode)
        //        updateShuffleLabel(playerState.playbackOptions.isShuffling)
        self.song.text = playerState.track.name //+ " - " + playerState.track.artist.name
        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            self.updateAlbumArtWithImage(image)
            self.updateCurrentSong(playerState: playerState)

            //        updateViewWithRestrictions(playerState.playbackRestrictions)
            //        updateInterfaceForPodcast(playerState: playerState)
        }

        
    }
    fileprivate func updatePlayPauseButtonState(_ paused: Bool) {
        let playPauseButtonImage = paused ? PlaybackButtonGraphics.playButtonImage() : PlaybackButtonGraphics.pauseButtonImage()
        self.state.setImage(playPauseButtonImage, for: UIControl.State())
        self.state.setImage(playPauseButtonImage, for: .highlighted)
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
        self.cover.image = image
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        self.cover.layer.add(transition, forKey: "transition")
    }
    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        MusicHandler?.spotifyHandler.appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else { return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
    
    func updateCurrentSong(playerState: SPTAppRemotePlayerState){
        let newSong = Song(title: playerState.track.name , duration: TimeInterval(playerState.track.duration), artist: playerState.track.artist.name, cover: cover.image!, album: playerState.track.album.name)
        MusicHandler?.currentSong = newSong
    }
    
 
    func initButtons(){
        state.setImage(PlaybackButtonGraphics.playButtonImage(), for: UIControl.State.normal)
        state.setImage(PlaybackButtonGraphics.playButtonImage(), for: UIControl.State.highlighted)
        nextSong.setImage(PlaybackButtonGraphics.nextButtonImage(), for: UIControl.State.normal)
        nextSong.setImage(PlaybackButtonGraphics.nextButtonImage(), for: UIControl.State.highlighted)
        state.showsTouchWhenHighlighted = true
        state.layer.cornerRadius = state.frame.width/2
        state.setBackgroundColor(color: .lightGray, forState: .highlighted)
        nextSong.showsTouchWhenHighlighted = true
        nextSong.layer.cornerRadius = state.frame.width/2
        nextSong.setBackgroundColor(color: .lightGray, forState: .highlighted)
        MusicHandler?.spotifyHandler.getPlayerState()
    }
    
    func reset(){
        let playPauseButtonImage = PlaybackButtonGraphics.playButtonImage()
        self.state.setImage(playPauseButtonImage, for: UIControl.State())
        self.state.setImage(playPauseButtonImage, for: .highlighted)
        cover.image = UIImage(named: "No Music")
        song.text = "Nothing Playing"
    }
  
    
    fileprivate func updateViewWithRestrictions(_ restrictions: SPTAppRemotePlaybackRestrictions) {
        nextSong.isEnabled = restrictions.canSkipNext
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


