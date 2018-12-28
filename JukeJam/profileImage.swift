//
//  profileImage.swift
//  JukeJam
//
//  Created by Rena fortier on 12/27/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit

class profileImage: UIImageView {
    
    public override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
//        self.backgroundColor = UIColor.white
//        self.layer.borderWidth = 5.0
//        self.layer.cornerRadius = 20.0
//        self.layer.borderColor = ourYellow.cgColor
    }
}
