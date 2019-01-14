import UIKit
import Foundation

class FocalButton: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.45
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:0.50, green:0.74, blue:0.62, alpha:1.0).cgColor
        self.backgroundColor = UIColor.white
    }
    
    
}
