//
//  SwiftIconFont+UIBarButtonItem.swift
//  SwiftIconFont
//
//  Created by Sedat Gökbek ÇİFTÇİ on 13.10.2017.
//  Copyright © 2017 Sedat Gökbek ÇİFTÇİ. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    func icon(from font: Fonts, code: String, ofSize size: CGFloat){
        var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.icon(from: font, ofSize: size)]
        let currentTextAttributes: [NSAttributedString.Key: Any]? = convertFromOptionalNSAttributedStringKeyDictionary(self.titleTextAttributes(for: UIControl.State())) as! [NSAttributedString.Key: Any]?
        
        if currentTextAttributes != nil {
            for (key, value) in currentTextAttributes! where key != .font {
                textAttributes[key] = value
            }
        }
        self.setTitleTextAttributes(textAttributes, for: .normal)
        self.setTitleTextAttributes(textAttributes, for: .highlighted)
        self.setTitleTextAttributes(textAttributes, for: .disabled)
        
        self.title = String.getIcon(from: font, code: code)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]?) -> [String: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
