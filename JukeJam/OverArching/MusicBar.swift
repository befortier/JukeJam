//
//  MusicBar.swift
//  JukeJam
//
//  Created by Rena fortier on 1/10/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit

class MusicBar: UIView {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var state: UIImageView!
    @IBOutlet weak var nextSong: UIImageView!
    @IBOutlet var containerView: UIView!
    
    var coverImage: UIImage? {
        didSet {
            cover.image = coverImage
        }
    }
    var stateImage: UIImage? {
        didSet {
            state.image = stateImage
        }
    }
    var nextSongImage: UIImage? {
        didSet {
            nextSong.image = nextSongImage
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
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
        setupView()
    }
    
    private func setupView() {

        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.75)
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.45
//        self.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.backgroundColor = UIColor.black
        self.nextSongImage = UIImage(named: "nextsong")
    }
    private func commonInit(){
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        // next: append the container to our view
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
