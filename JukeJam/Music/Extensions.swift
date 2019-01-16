import Foundation
import ChameleonFramework
extension UIView{
    func assignImageGradientColor(colors: [UIColor]){
        let gradientColor = GradientColor(.diagonal, frame: self.frame, colors: colors)
        self.backgroundColor = gradientColor
    }
    func getImageGradientColor(colors: [UIColor]) -> UIColor{
        let gradientColor = GradientColor(.diagonal, frame: self.frame, colors: colors)
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
