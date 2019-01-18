
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController {

    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var prevSong: UIImageView!
    @IBOutlet weak var nextSong: UIImageView!
    @IBOutlet weak var state: UIImageView!
    var currentSong: Song?
    var averageColor: UIColor?{
        didSet{
            updateColorUI()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        initWaitingGame()
        self.modalPresentationCapturesStatusBarAppearance = true
        self.gradientBackground.assignImageGradientColor(colors: (self.currentSong?.imageColors)!)
        self.gradientBackground.addFadeOut()
        cover.layer.borderWidth = 0.1
        cover.layer.cornerRadius = 7
        cover.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        cover.layer.shadowRadius = 1.7
        cover.layer.shadowOpacity = 0.45
        cover.image = currentSong?.cover
        song.text = self.currentSong?.title
        more.text = "\((currentSong?.artist)!) - \((currentSong?.album)!)"
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewFunc))
        self.closeView.addGestureRecognizer(tap)
    }
    
    @objc func closeViewFunc(){
        print("HERE testing")
        self.dismiss(animated: true)
        let delegate = self.transitioningDelegate as! SPStorkTransitioningDelegate
//        delegate.
    }
    
    
    func updateColorUI(){
        cover.layer.borderColor = averageColor!.inverse().cgColor
        cover.layer.shadowColor = averageColor!.inverse().cgColor
        more.textColor = averageColor!.inverse()
        volume.tintColor = averageColor!.inverse()
        view.setNeedsDisplay()
        view.setNeedsLayout()
    }
    
    func initWaitingGame(){
            self.averageColor = UIColor.clear
            if self.currentSong?.imageAvColor != nil{
                self.averageColor = self.currentSong?.imageAvColor
            }
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

