//
//  MusicBar.swift
//  JukeJam
//
//  Created by Rena fortier on 1/10/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit
import ShadowView

class MusicBar: UIView {
    @IBOutlet weak var cover: UIImageView!
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
//    var stateImage: UIImage? {
//        didSet {
//            state.image = stateImage
//        }
//    }
//    var nextSongImage: UIImage? {
//        didSet {
//            nextSong.image = nextSongImage
//        }
//    }
    var songText: String? {
        didSet {
            song.text = songText
        }
    }
    
    
    @IBAction func test(_ sender: UIButton) {
        sender.tintColor = random()
    }
    func random2() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
     func random() -> UIColor {
        return UIColor(red:   random2(),
                       green: random2(),
                       blue:  random2(),
                       alpha: 1.0)
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
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.75)
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.45
//        self.nextSongImage = UIImage(named: "nextsong")
        self.cover.layer.cornerRadius = 8.0
        self.cover.clipsToBounds = true



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
