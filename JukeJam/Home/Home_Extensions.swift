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
