import Foundation
import ChameleonFramework
extension UIView{
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func assignImageGradientColor(colors: [UIColor]){
        if colors.count == 0{
            return
        }
        if colors.count == 1{
             self.backgroundColor = colors[0]
            return
        }
        let gradientColor = GradientColor(.diagonal, frame: self.frame, colors: colors)
        self.backgroundColor = gradientColor
    }
    func getImageGradientColor(colors: [UIColor]) -> UIColor{
        if colors.count == 0{
            return UIColor.clear
        }
        if colors.count == 1{
            return colors[0]
        }
        let gradientColor = GradientColor(.diagonal, frame: self.frame, colors: colors)
        return gradientColor
    }
    func addFadeOut(){
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 0, 0.9, 1]
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

    var hue: CGFloat
    {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return hue
    }
}
extension String {
    func encodeStringAsUrlParameter(_ value: String) -> String {
        let escapedString = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString!
    }
}

extension Dictionary {
    
    func urlParametersRepresentation() -> String {
        // Add the necessary parameters
        var pairs = [String]()
        for (key, value) in self {
            let keyString = key as! String
            let valueString = value as! String
            let encodedKey = keyString.encodeStringAsUrlParameter(key as! String)
            let encodedValue = valueString.encodeStringAsUrlParameter(value as! String)
            let encoded = String(format: "%@=%@", encodedKey, encodedValue);
            pairs.append(encoded)
        }
        
        return pairs.joined(separator: "&")
    }
}
