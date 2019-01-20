
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController, MusicHandlerDelegate {
    
    

    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var prevSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet weak var state: UIButton!
    var musicHandler: MusicHandler?
    var currentSong: Song?{
        didSet{
            musicHandler?.spotifyHandler.getPlayerState()
        }
    }
    var averageColor: UIColor?
    var musicUIController: MusicUIController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        waitForColors()
        closingGesture()
//         musicUIController = MusicUIController(state: state, next: nextSong, cover: cover, song: song, handler: musicHandler!)
        
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
    }
    
    @objc func closeViewFunc(){
        musicHandler?.delegate = musicHandler?.musicBar
        self.dismiss(animated: true)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                toggleGestures(allow:false)
                volume.setThumbImage(UIImage(named: "Bigger Circle"), for: UIControl.State.normal)
                volume.tintColor = self.averageColor ?? UIColor.darkGray


            case .ended:
                toggleGestures(allow: true)
                volume.tintColor = UIColor.darkGray
                volume.setThumbImage(UIImage(named: "Small Circle"), for: .normal)

            default:
                break
            }
        }
    }
    
    func toggleGestures(allow: Bool){
        let gestures = view.gestureRecognizers
        var count = 0
        while(count < (gestures?.count)!){
            gestures![count].isEnabled = allow
            count += 1
        }
    }

    

    func updateColorUI(){
        self.averageColor = self.currentSong?.imageAvColor ?? UIColor.clear
        if self.currentSong?.imageAvColor == nil{
            return
        }
        cover.layer.borderColor = averageColor!.inverse().cgColor
        cover.layer.shadowColor = averageColor!.inverse().cgColor
        more.textColor = averageColor
        volume.tintColor = UIColor.darkGray
        view.setNeedsDisplay()
        view.setNeedsLayout()
    }
    
    func waitForColors(){
        updateColorUI()
        while self.currentSong?.imageAvColor == nil{
            
        }
        updateColorUI()
    }
    
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        musicUIController?.updateViewWithPlayerState(playerState)
    }
    
    func reset(){
        musicUIController?.reset()
        
    }


}


