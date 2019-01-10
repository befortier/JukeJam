//
//  MusicControllerBar.swift
//  JukeJam
//
//  Created by Rena fortier on 1/9/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit

class MusicControllerBar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nextSong: UIImageView!
    @IBOutlet weak var state: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var cover: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect){
        super.init(frame:frame)
        setupView()
        commonInit()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupView()
        commonInit()
    }
    
    private func setupView() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.75)
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.45
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MusicControllerBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
