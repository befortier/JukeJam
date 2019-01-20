
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController, MusicHandlerDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var smallerCoverView: UIView!
    
    @IBOutlet weak var smallerCover: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
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
    private var lastContentOffset: CGFloat = 0
    private var originalCoverViewFrame: CGRect!
    var viewBigger: Bool!


    override func viewDidLoad() {
        super.viewDidLoad()
        waitForColors()
        initUI()
        closingGesture()
        scrollView.delegate = self
        viewBigger = false
        originalCoverViewFrame = coverView.frame
//        print("HERE frame1," , state.frame)
//        print("HERE big frame1", scrollView.frame)

//         musicUIController = MusicUIController(state: state, next: nextSong, cover: cover, song: song, handler: musicHandler!)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var const: CGFloat = 220
        var scrollOffset: CGFloat = 250
        var photoOffsetX: CGFloat = 30
//        var photoOffsetY: CGFloat
        if scrollView.contentOffset.y >= scrollOffset && !viewBigger {
            print("HERE offsett," , scrollView.contentOffset.y)
            gradientBackground.frame = CGRect(x: gradientBackground.frame.minX, y: gradientBackground.frame.minY, width: view.frame.width, height: gradientBackground.frame.height - const)
            coverView.frame = CGRect(x: gradientBackground.frame.minX + photoOffsetX, y: gradientBackground.frame.minY + gradientBackground.frame.height, width: view.frame.width, height: gradientBackground.frame.height - const)
            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY - const, width: view.frame.width, height: scrollView.frame.height + const)
            gradientBackground.setNeedsDisplay()
            gradientBackground.setNeedsLayout()
            coverView.isHidden = true
            smallerCoverView.isHidden = false

            viewBigger = true
            scrollView.contentOffset.y = -10
//            scrollView.contentOffset.y =
            volume.isHidden = true



        }
       else if scrollView.contentOffset.y < (-50) && viewBigger {
            print("HERE offsett2," , scrollView.contentOffset.y)
            gradientBackground.frame = CGRect(x: gradientBackground.frame.minX, y: gradientBackground.frame.minY, width: view.frame.width, height: gradientBackground.frame.height + const)
            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY + const, width: view.frame.width, height: scrollView.frame.height - const)
            coverView.frame = originalCoverViewFrame
            gradientBackground.setNeedsDisplay()
            gradientBackground.setNeedsLayout()
            viewBigger = false
            coverView.isHidden = false
            smallerCoverView.isHidden = true
//            scrollView.contentOffset.y = 0
            volume.isHidden = false

            
        }
        
        
     
        
        // update the new position acquired
        print(" offset",  scrollView.contentOffset.y)
        self.lastContentOffset = scrollView.contentOffset.y
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
        smallerCoverView.isHidden = true
      
        
        
        cover.layer.cornerRadius = 10
        cover.clipsToBounds = true
        cover.layer.borderWidth = 0.1
        
        coverView.layer.shadowOffset = CGSize(width: 3, height: 3)
        coverView.layer.shadowRadius = 4.0
        coverView.layer.shadowOpacity = 0.7
        coverView.layer.masksToBounds = false
        
        smallerCover.layer.cornerRadius = 10
        smallerCover.clipsToBounds = true
        smallerCover.layer.borderWidth = 0.1
        
        smallerCoverView.layer.shadowOffset = CGSize(width: 3, height: 3)
        smallerCoverView.layer.shadowRadius = 4.0
        smallerCoverView.layer.shadowOpacity = 0.7
        smallerCoverView.layer.masksToBounds = false
        cover.image = currentSong?.cover
        smallerCover.image = cover.image

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
                volume.tintColor = (self.averageColor ?? UIColor.darkGray).inverse()
                viewBigger = false

                
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


