import Foundation
import ChameleonFramework
extension UIView{
    func assignImageGradientColor(colors: [UIColor]){
        if colors.count == 1{
             self.backgroundColor = colors[0]
            return
        }
        let gradientColor = GradientColor(.topToBottom, frame: self.frame, colors: colors)
        self.backgroundColor = gradientColor
    }
    func getImageGradientColor(colors: [UIColor]) -> UIColor{
        if colors.count == 1{
            return colors[0]
        }
        let gradientColor = GradientColor(.topToBottom, frame: self.frame, colors: colors)
        return gradientColor
    }
    func addFadeOut(){
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 1]
        self.layer.mask = gradientMaskLayer
    }
}
extension UIColor {
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black // Return a default colour
    }
}
