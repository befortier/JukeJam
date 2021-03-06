//
//  SeeMoreController.swift
//  JukeJam
//
//  Created by Rena fortier on 1/3/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import UIKit

class SeeMoreController: UIViewController {
    @IBOutlet weak var CollectionView: UICollectionView!
    var Info: [Any?] = []
    var myTitle = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myTitle
        establishCells()
        CollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func establishCells(){
        Info.append(coverArt(title: "Baby Boy Blue", author: "Nirvana", image: UIImage(named: "album1")!))
        Info.append(coverArt(title: "Nothing Was the Same ", author: "Drake", image: UIImage(named: "album2")!))
        Info.append(coverArt(title: "Astroworld", author: "Travis Scott", image: UIImage(named: "album3")!))
        Info.append(coverArt(title: "Kulture II", author: "Migos", image: UIImage(named: "album4")!))
        Info.append(coverArt(title: "The Life of Pablo", author: "Kanye West", image: UIImage(named: "album5")!))
        CollectionView.establishFullScreenCells()

    }
    
}



extension SeeMoreController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCell", for: indexPath) as! FocalCell
        cell.coverArt = (Info[indexPath.item] as! coverArt)
        print(cell)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count \(Info.count)")
        return Info.count
    }
    
}
