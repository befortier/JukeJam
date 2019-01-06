//
//  FocalCell.swift
//  JukeJam
//
//  Created by Rena fortier on 1/2/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit

class FocalCell: UICollectionViewCell {
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    var coverArt: coverArt? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI(){
        if let cover = coverArt{
            image.image =  cover.image
            author.text = cover.author
            title.text = cover.title
        }
        else{
            image.image = nil
            author.text = nil
            title.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.image.layer.cornerRadius = 8.0
        self.image.clipsToBounds = true
        self.contentView.layoutIfNeeded()
        self.title.numberOfLines = 3;
        self.title.sizeToFit()
    }
}

class coverArt: NSObject{
    var title: String?
    var author: String?
    var image: UIImage?

    init(title: String, author: String, image: UIImage){
        self.title = title
        self.author = author
        self.image = image
    }
}
