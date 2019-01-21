
import UIKit
import SPStorkController
import ChameleonFramework

class SongController: UIViewController, MusicHandlerDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var ImagetoTop: NSLayoutConstraint!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var seeLessButton: UIButton!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var playbackLocation: UISlider!
    @IBOutlet weak var prevSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet weak var state: UIButton!
    var musicHandler: MusicHandler?
    var currentSong: Song?{
        didSet{
            musicHandler?.updateUI()
        }
    }
    let newCoverFrame = UIView()
    let newCover = UIImageView()

    var averageColor: UIColor?
    var musicUIController: MusicUIController!
    var viewBigger: Bool!
    var allowChange: Bool!
    var scrollOffset: CGFloat!
    var const: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        initBasics()
        initMovableImageView()
        waitForColors()
//        initUI()
        closingGesture()
        musicUIController = MusicUIController(state: state, next: nextSong, cover: cover, song: song, prev: prevSong, handler: musicHandler!)
        
    }
    
    func initBasics(){
        scrollOffset = view.frame.height * 0.15
        const = view.frame.height * 0.33
        seeLessButton.isHidden = true
        coverView.isHidden = true
        allowChange = true
        scrollView.delegate = self
        viewBigger = false
        musicHandler?.delegate = self
    }
    
    func initMovableImageView(){
        newCoverFrame.frame = coverView.frame
        newCover.frame = cover.frame
        newCoverFrame.addSubview(newCover)
        self.gradientBackground.addSubview(newCoverFrame)
        self.gradientBackground.bringSubviewToFront(newCoverFrame)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if allowChange{
            if scrollView.contentOffset.y >= scrollOffset && !viewBigger {
                print("HERE 123called from here")
                
                toggleScrollUI(adjust: true)
            }
            else if scrollView.contentOffset.y < (-50) && viewBigger {
                print("HERE called from here")
                toggleScrollUI(adjust: false)
            }
        }
    }
    @IBAction func seeLess(_ sender: Any) {
        toggleScrollUI(adjust: false)

    }
    
    @IBAction func seeMore(_ sender: Any) {
        toggleScrollUI(adjust: true)
    }
    func toggleScrollUI(adjust: Bool){
        allowChange = false
        var adjustRate: CGFloat = 0.41
        if !adjust {
            adjustRate = 1
        }
      
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.layoutSubviews, animations: {
            self.gradientBackground.frame = CGRect(x: self.gradientBackground.frame.minX, y: self.gradientBackground.frame.minY, width: self.view.frame.width, height: self.gradientBackground.frame.height - self.const)
            self.newCoverFrame.center.y = self.gradientBackground.center.y + self.scrollOffset/10
            self.newCoverFrame.transform = CGAffineTransform(scaleX: adjustRate, y: adjustRate)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.minX, y: self.scrollView.frame.minY - self.const, width: self.view.frame.width, height: self.scrollView.frame.height + self.const)
           self.buttonsView.isHidden = adjust
            self.viewBigger = adjust
            self.seeMoreButton.isHidden = adjust
            self.seeLessButton.isHidden = !adjust

//            self.scrollView.setContentOffset(self.scrollView.contentOffset, animated: false)
            self.playbackLocation.isHidden = adjust
        }, completion: {
            (value: Bool) in
            self.const = -self.const
            self.allowChange = true
        })
    }
    
    func closingGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewFunc))
        self.closeView.addGestureRecognizer(tap)
        playbackLocation.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

    }
    
    
    func initUI(){
        self.modalPresentationCapturesStatusBarAppearance = true
        self.gradientBackground.assignImageGradientColor(colors: (self.currentSong?.imageColors)!)
        self.gradientBackground.addFadeOut()
      
        
        
        newCover.layer.cornerRadius = 10
        newCover.clipsToBounds = true
        newCover.layer.borderWidth = 0.1
        
        newCoverFrame.layer.shadowOffset = CGSize(width: 3, height: 3)
        newCoverFrame.layer.shadowRadius = 4.0
        newCoverFrame.layer.shadowOpacity = 0.7
        newCoverFrame.layer.masksToBounds = false
        
     
        newCover.image = currentSong?.cover

        song.text = self.currentSong?.title
        more.text = "\((currentSong?.artist)!) - \((currentSong?.album)!)"
        playbackLocation.setThumbImage(UIImage(named: "Small Circle"), for: .normal)
    }
    
    @objc func closeViewFunc(){
        self.dismiss(animated: true)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                toggleGestures(allow:false)
                playbackLocation.setThumbImage(UIImage(named: "Bigger Circle"), for: UIControl.State.normal)
                playbackLocation.tintColor = (self.averageColor ?? UIColor.darkGray).inverse()
                viewBigger = false

                
            case .ended:
                toggleGestures(allow: true)
                playbackLocation.tintColor = UIColor.darkGray
                playbackLocation.setThumbImage(UIImage(named: "Small Circle"), for: .normal)

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
            newCover.layer.borderColor = averageColor!.inverse().cgColor
            newCoverFrame.layer.shadowColor = averageColor!.inverse().cgColor
            playbackLocation.tintColor = UIColor.darkGray
            view.setNeedsDisplay()
            view.setNeedsLayout()
            
        }
        initUI()
       
        
    }
    
    func waitForColors(){
        updateColorUI()
        DispatchQueue.global(qos: .background).async {
            while self.currentSong?.imageAvColor == nil{
                
            }
            DispatchQueue.main.async {
                self.updateColorUI()
                self.gradientBackground.setNeedsDisplay()
                self.gradientBackground.setNeedsLayout()
                  }
                }       
    }
    
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
//        print("HERE this is the new delegate")
        musicUIController?.updateCurrentSong(playerState: playerState)
    }
    
    func reset(){
        musicUIController?.reset()
        
    }

    @IBAction func prevSong(_ sender: Any) {
        musicHandler?.prevSong()
    }
    @IBAction func changeState(_ sender: Any) {
        musicHandler?.PlayPauseMusic()
    }
    @IBAction func nextSong(_ sender: Any) {
        musicHandler?.nextSong()

    }
    override func viewDidDisappear(_ animated: Bool) {
//        print("HERE dismissed")
        musicHandler?.delegate = musicHandler?.musicBar
        musicHandler?.updateUI()
        
    }
}


