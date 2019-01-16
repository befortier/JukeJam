//
//  MusicBar.swift
//  JukeJam
//
//  Created by Rena fortier on 1/10/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit
import ShadowView

protocol MusicBarDelegate: class {
    func expandSong(song: Song)
}

class MusicBar: UIView, SongSubscriber {
    var currentSong: Song? {
        didSet{
            configure(song: self.currentSong)
            
        }
    }
    weak var delegate: MusicBarDelegate?

    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cover: UIImageView!{
        didSet{
            //LEFT OFF HERE NO SONG EXISTING REALLY
            self.backgroundView.backgroundColor = song.imageColors[0]
        }
    }
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var state: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet var containerView: UIView!
    let exampleShadowContainerView = ShadowView()

    var coverImage: UIImage? {
        didSet {
            cover.image = coverImage
        }
    }
    var songText: String? {
        didSet {
            song.text = songText
        }
    }
    
  
    override init(frame: CGRect){
        super.init(frame:frame)
        commonInit()
        setupView()
        initSongController()
        currentSong = Song(title: "Started From the Bottom Now Were Here", duration: 100, artist: "Drake", cover: UIImage(named: "album4")!)
        
        configure(song: currentSong)

    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
        setupView()
        initSongController()
        configure(song: nil)
    }
    
    private func initSongController(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSongController))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func showSongController(){
        print("HERE ",currentSong)
        guard let song = currentSong else {
            print("HERE ERROR")
            return
        }
        
        delegate?.expandSong(song: song)
        
        
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
            self.song.text = song.title
//            song.loadSongImage { [weak self] image in
                self.cover.image = song.cover
 
            
//            }
        } else {
            self.song.text = nil
            self.cover.image = nil
        }
        currentSong = song
    }
}

extension MusicBar: MaxiPlayerSourceProtocol {
    var originatingFrameInWindow: CGRect {
        return (self.frame)
    }
    
    var originatingCoverImageView: UIImageView {
        return cover
    }
}
