
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController, MusicHandlerDelegate {
    
    

    @IBOutlet weak var coverView: UIView!
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
        waitForColors()
        initUI()
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
 
      
        
        
        cover.layer.cornerRadius = 10
        cover.clipsToBounds = true
        cover.layer.borderWidth = 0.1
        
        coverView.layer.shadowOffset = CGSize(width: 3, height: 3)
        coverView.layer.shadowRadius = 4.0
        coverView.layer.shadowOpacity = 0.7
        coverView.layer.masksToBounds = false
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
        if self.currentSong?.imageAvColor != nil{
            averageColor = self.currentSong?.imageAvColor
            cover.layer.borderColor = averageColor!.inverse().cgColor
            coverView.layer.shadowColor = averageColor!.inverse().cgColor
            volume.tintColor = UIColor.darkGray
            view.setNeedsDisplay()
            view.setNeedsLayout()
            
        }
       
        
    }
    
    func waitForColors(){
        updateColorUI()
        DispatchQueue.global(qos: .background).async {
            while self.currentSong?.imageAvColor == nil{
                
            }
            DispatchQueue.main.async {
                self.updateColorUI()
                  }
                }       
    }
    
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        musicUIController?.updateCurrentSong(playerState: playerState)
    }
    
    func reset(){
        musicUIController?.reset()
        
    }


}


