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
    @IBOutlet weak var title: UITextView!
    var coverArt: coverArt? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI(){
        overView.layer.cornerRadius = 3.0
        overView.clipsToBounds = false
        overView.layer.shadowRadius = 2
        overView.layer.shadowOpacity = 0.8
        overView.layer.shadowOffset = CGSize(width: 5, height: 10)
      

        if let cover = coverArt{
            image.image = coverArt?.image
            author.text = coverArt?.author
            title.text = coverArt?.title
        }
        else{
            image.image = nil
            author.text = nil
            title.text = nil
        }
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        print("HERE")
        title.sizeToFit()
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
