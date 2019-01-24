import UIKit

class loginButton: UIButton {
    public override func awakeFromNib() {
        let useColor = UIColor.stem
        self.setTitleColor(useColor, for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 5.0
        self.layer.cornerRadius = 20.0
        self.layer.borderColor = useColor.cgColor
    }
    


}
