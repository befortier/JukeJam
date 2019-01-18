
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
    var musicHandler: MusicHandler?
    var currentSong: Song?
    var averageColor: UIColor?{
        didSet{
            updateColorUI()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        initWaitingGame()
        initUI()
        closingGesture()
    }
    
    func closingGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewFunc))
        self.closeView.addGestureRecognizer(tap)
        volume.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

    }
    func initUI(){
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
        volume.setThumbImage(UIImage(named: "Small Circle"), for: .normal)
        volume.setThumbImage(UIImage(named: "Bigger Circle"), for: UIControl.State.selected)
           volume.setThumbImage(UIImage(named: "Bigger Circle"), for: UIControl.State.highlighted)
        

    }
    @objc func closeViewFunc(){
        self.dismiss(animated: true)
    }
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
            // handle drag began
               let gestures = view.gestureRecognizers
               var count = 0
               while(count < (gestures?.count)!){
                gestures![count].isEnabled = false
                count += 1
               }
             
                view.isUserInteractionEnabled = false
                volume.tintColor = self.averageColor!
                view.setNeedsDisplay()
                view.setNeedsLayout()
            case .moved:
            // handle drag moved
                view.setNeedsDisplay()
                view.setNeedsLayout()
            case .ended:
            // handle drag ended
                let gestures = view.gestureRecognizers
                var count = 0
                while(count < (gestures?.count)!){
                    gestures![count].isEnabled = true
                    count += 1
                }

                volume.tintColor = UIColor.darkGray
                view.isUserInteractionEnabled = true
                view.setNeedsDisplay()
                view.setNeedsLayout()
            default:
                break
            }
        }
    }

    
    @IBAction func sliderReleased(_ sender: Any) {
       
    }
    func updateColorUI(){
        if averageColor == UIColor.clear{
            return
        }
        cover.layer.borderColor = averageColor!.inverse().cgColor
        cover.layer.shadowColor = averageColor!.inverse().cgColor
        more.textColor = averageColor
        volume.tintColor = UIColor.darkGray
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

