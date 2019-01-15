
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController {

    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var prevSong: UIImageView!
    @IBOutlet weak var nextSong: UIImageView!
    @IBOutlet weak var state: UIImageView!
    var coverImage: UIImage!
    var songText: String!
    var moreText: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationCapturesStatusBarAppearance = true
        cover.image = coverImage
        song.text = songText
        more.text = "This is a giant test - to see if the text will eventualy wrap around"


        assignGradient()
    }
    
  
    
    func assignGradient(){
        print("HERE why taking so long2")
        var colors = ColorsFromImage(cover.image!, withFlatScheme: true)
//        colors.sort(by: {$0.hue < $1.hue})
        
        print("HERE why taking so long13")

        let averageColor = AverageColorFromImage(cover.image!)
        print("HERE why taking so long23")

        let gradientColor = GradientColor(.diagonal, frame: gradientBackground.frame, colors: [colors[1],colors[0]])
        print("HERE why taking so long33")

        gradientBackground.backgroundColor = gradientColor
        cover.layer.borderColor = averageColor.cgColor
        cover.layer.borderWidth = 5.0

        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = gradientBackground.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 0, 0.9, 1]
        gradientBackground.layer.mask = gradientMaskLayer
        more.textColor = averageColor
        volume.tintColor = averageColor
        print("HERE why taking so long4")

    }

}
extension UIColor
{
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

