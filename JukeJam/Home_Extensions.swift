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
        let size: CGSize = CGSize(width: 25, height: 25)
        let buttonImage = UIImage.fontAwesomeIcon(name: type, style: .solid, textColor: .gray, size: size).withRenderingMode(.alwaysOriginal)
        button.setImage(buttonImage, for: .normal)
        button.frame = CGRect(x: 0, y:0, width: 34, height: 34)
        button.addTarget(self, action: selector, for: .touchUpInside)
        let retButton = UIBarButtonItem(customView: button)
        return retButton
    }
    
    
}
