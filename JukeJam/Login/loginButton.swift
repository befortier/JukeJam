//
//  loginButton.swift
//  iVote
//
//  Created by Rena fortier on 12/24/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit

class loginButton: UIButton {
    public override func awakeFromNib() {
        let ourYellow = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
        self.setTitleColor(ourYellow, for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 5.0
        self.layer.cornerRadius = 20.0
        self.layer.borderColor = ourYellow.cgColor
    }
    


}
