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
