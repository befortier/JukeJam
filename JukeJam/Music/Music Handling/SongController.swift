
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
    var isPaused: Bool = true
    let newCoverFrame = UIView()
    let newCover = UIImageView()
    var averageColor: UIColor?
    var musicUIController: MusicUIController!
    var viewBigger: Bool!
    var allowChange: Bool!
    var scrollOffset: CGFloat!
    var const: CGFloat!
    var timer = Timer()
    
    
    

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()

        initBasics()
        initUI()
        initMovableImageView()
        waitForColors()
        closingGesture()
        musicUIController = MusicUIController(state: state, next: nextSong, cover: newCover, song: song, prev: prevSong,  handler: musicHandler!)
        updateSlider()
    }
    
    func initBasics(){
        scrollOffset = view.frame.height * 0.15
        const = view.frame.height * 0.33
        seeLessButton.isHidden = true
        coverView.isHidden = true
        allowChange = true
        scrollView.delegate = self
        viewBigger = false
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
                toggleScrollUI(adjust: true)
            }
            else if scrollView.contentOffset.y < (-50) && viewBigger {
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
      
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.layoutSubviews, animations: {
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
    
    func setColors(){
        self.gradientBackground.assignImageGradientColor(colors: (musicHandler!.currentSong?.imageColors)!)
        self.gradientBackground.addFadeOut()

    }
    
  
    
    func initUI(){
        self.modalPresentationCapturesStatusBarAppearance = true
        setColors()
      
        newCover.layer.cornerRadius = 10
        newCover.clipsToBounds = true
        newCover.layer.borderWidth = 0.1
        
        newCoverFrame.layer.shadowOffset = CGSize(width: 3, height: 3)
        newCoverFrame.layer.shadowRadius = 4.0
        newCoverFrame.layer.shadowOpacity = 0.7
        newCoverFrame.layer.masksToBounds = false
        

    }
    
  
 
    func assignMoreText(song: Song){
        //TEST with multiple artists see what is looks like
        var moreString:String = ""
        if song.artist?.count != 0{
            
            song.artist?.forEach({ (Artist) in
                moreString += "\((Artist.name)!), "
            })
            moreString.removeLast(2)
            if song.album != nil {
                if song.album?.name != ""{
                    moreString += " - \((song.album?.name)!)"
                }
            }
        }
        self.more.text = moreString
    }

    func updateColorUI(){
        if musicHandler!.currentSong?.imageAvColor != nil{
            averageColor = musicHandler!.currentSong?.imageAvColor
            newCover.layer.borderColor = averageColor!.inverse().cgColor
            newCoverFrame.layer.shadowColor = averageColor!.inverse().cgColor
            playbackLocation.tintColor = UIColor.darkGray
        }
        setColors()
    }
    
    func waitForColors(){
        updateColorUI()
        DispatchQueue.global(qos: .background).async {
            while self.musicHandler!.currentSong?.imageAvColor == nil{
                
            }
            while self.viewBigger{
                
            }
            DispatchQueue.main.async {
                self.setColors()
                self.gradientBackground.setNeedsDisplay()
                self.gradientBackground.setNeedsLayout()
                  }
            while self.musicHandler!.currentSong?.imageColors.count != 2{
                
            }
            while self.viewBigger{
                
            }
            DispatchQueue.main.async {
                self.setColors()
                self.gradientBackground.setNeedsDisplay()
                self.gradientBackground.setNeedsLayout()
            }
                }       
    }
    
    func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        if viewBigger{
            toggleScrollUI(adjust: false)
        }
        if (musicHandler?.spotifyHandler.appRemote.isConnected)!{
            musicUIController?.updateView(playerState: playerState)
        }
    }
    
    func updateUI(song: Song){
        self.newCover.image = song.album?.cover
        waitForColors()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        self.newCover.layer.add(transition, forKey: "transition")
        self.song.text = song.title
        assignMoreText(song: song)
        updateSlider()
    }
    
    func updateState(state: SPTAppRemotePlayerState){
        musicUIController.updatePlayPauseButtonState(state.isPaused)
        musicUIController.updateViewWithRestrictions(state.playbackRestrictions)
        if !state.playbackRestrictions.canSeek{
            playbackLocation.setThumbImage(UIImage(), for: .normal)
        }
        else{
            playbackLocation.setThumbImage(UIImage(named: "Small Circle"), for: .normal)
        }
        playbackLocation.isEnabled = !state.playbackRestrictions.canSeek
        self.isPaused = state.isPaused
        playbackLocation.value = Float(state.playbackPosition)

    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        if !self.isPaused{
            playbackLocation.value += 100
        }
    }

    func updateSlider(){
        if let song = musicHandler?.currentSong{
            playbackLocation.minimumValue = 0
            playbackLocation.maximumValue = Float(song.duration)
        }
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
        musicHandler?.delegate = musicHandler?.musicBar
        musicHandler?.updateUI()
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

    
}


