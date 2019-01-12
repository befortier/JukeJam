//
//  File.swift
//  JukeJam
//
//  Created by Rena fortier on 12/31/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension UIViewController{
    
    func getTabBarButton(type: FontAwesome, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        let size: CGSize = CGSize(width: 30, height: 30)
        let buttonImage = UIImage.fontAwesomeIcon(name: type, style: .solid, textColor: .white, size: size).withRenderingMode(.alwaysOriginal)
        button.setImage(buttonImage, for: .normal)
        button.frame = CGRect(x: 0, y:0, width: 40, height: 40)
        button.addTarget(self, action: selector, for: .touchUpInside)
        let retButton = UIBarButtonItem(customView: button)
        return retButton
    }
}


extension UICollectionView{
    func establishFullScreenCells(){
        let cellModifier: CGFloat = 0.42
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellModifier)
        let cellHeight = floor(screenSize.height * (cellModifier - 0.07))
        let insetX:CGFloat = (screenSize.width - 2*cellWidth)/3.0
        let insetY: CGFloat = 0
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.setCollectionViewLayout(layout, animated: false)
        self.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func establishDivCells(){
        let insetX:CGFloat = 8
        let insetY: CGFloat = 8
        self.setCollectionViewLayout(self.collectionViewLayout as! UICollectionViewFlowLayout, animated: false)
        self.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
}
