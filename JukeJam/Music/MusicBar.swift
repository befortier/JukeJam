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

class MusicBar: UIView, MusicHandlerDelegate {
    
    weak var delegate: MusicBarDelegate?
    var musicHandler: MusicHandler?

    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var state: UIButton!
    var coverImage: UIImage?
    var songText: String?
  
    var musicUIController: MusicUIController?
  
     init(frame: CGRect, handler: MusicHandler){
        super.init(frame:frame)
        self.musicHandler = handler
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
        musicUIController = MusicUIController(state: state, next: nextSong, cover: cover, song: song, handler: musicHandler!)
      

    }
    
    private func initSongController(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSongController))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func showSongController(){
        guard let song = musicHandler!.currentSong else {
            return
        }
        if (musicHandler?.spotifyHandler.appRemote.isConnected)!{
            delegate?.expandSong(song: song)
        }
        else{
            print("NOT connected")
        }
     
        
        
    }
    
    @IBAction func stateChange(_ sender: Any) {
        musicHandler?.PlayPauseMusic()
    }
    
    @IBAction func nextSong(_ sender: Any) {
        musicHandler?.nextSong()
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
    
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        if (musicHandler?.spotifyHandler.appRemote.isConnected)!{
            musicUIController?.updateCurrentSong(playerState: playerState)
        }
    }
    
    func reset(){
        musicUIController?.reset()

    }
 

}








