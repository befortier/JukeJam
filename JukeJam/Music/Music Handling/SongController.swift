
import UIKit
import SPStorkController
import ChameleonFramework
import WCLShineButton
import AVFoundation
import MediaPlayer
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
    var UIOffsetConst: CGFloat!
    var playbackTimer = Timer()
    var volumeBackgroundView: UIView!
    var volumeSlider: VolumeSlider!
    var volumeButton: WCLShineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTimer()
        addButtons()
        initBasics()
        initUI()
        initMovableImageView()
        waitForColors()
        closingGesture()
        musicUIController = MusicUIController(state: state, next: nextSong, cover: newCover, song: song, prev: prevSong,  handler: musicHandler!)
        updateSlider()
        updateUI(song: (musicHandler?.currentSong)!)
    }
    
    func initBasics(){
        scrollOffset = view.frame.height * 0.15
        UIOffsetConst = view.frame.height * 0.33
        seeLessButton.isHidden = true
        coverView.isHidden = true
        allowChange = true
        scrollView.delegate = self
        viewBigger = false
        playbackLocation.minimumValue = 0
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
        hideVolume()
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.layoutSubviews, animations: {
            self.gradientBackground.frame = CGRect(x: self.gradientBackground.frame.minX, y: self.gradientBackground.frame.minY, width: self.view.frame.width, height: self.gradientBackground.frame.height - self.UIOffsetConst)
            self.newCoverFrame.center.y = self.gradientBackground.center.y + self.scrollOffset/10
            self.newCoverFrame.transform = CGAffineTransform(scaleX: adjustRate, y: adjustRate)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.minX, y: self.scrollView.frame.minY - self.UIOffsetConst, width: self.view.frame.width, height: self.scrollView.frame.height + self.UIOffsetConst)
           self.buttonsView.isHidden = adjust
            self.viewBigger = adjust
            self.seeMoreButton.isHidden = adjust
            self.seeLessButton.isHidden = !adjust
            self.playbackLocation.isHidden = adjust
        }, completion: {
            (value: Bool) in
            self.UIOffsetConst = -self.UIOffsetConst
            self.allowChange = true
        })
    }
    
    func closingGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeViewFunc))
        self.closeView.addGestureRecognizer(tap)
    }
    
    func setColors(){
        self.gradientBackground.assignImageGradientColor(colors: (musicHandler!.currentSong?.album?.imageColors)!)
        self.gradientBackground.addFadeOut()

    }
    
    
    @objc func closeViewFunc(){
        self.dismiss(animated: true)
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
        if musicHandler!.currentSong?.album?.imageAvColor != nil{
            averageColor = musicHandler!.currentSong?.album?.imageAvColor
            newCover.layer.borderColor = averageColor!.inverse().cgColor
            newCoverFrame.layer.shadowColor = averageColor!.inverse().cgColor
            playbackLocation.tintColor = UIColor.darkGray
        }
        setColors()
    }
    
    func waitForColors(){
        updateColorUI()
        DispatchQueue.global(qos: .background).async {
            while self.musicHandler!.currentSong?.album?.imageAvColor == nil{
                
            }
            while self.viewBigger{
                
            }
            DispatchQueue.main.async {
                self.setColors()
                self.gradientBackground.setNeedsDisplay()
                self.gradientBackground.setNeedsLayout()
                  }
            while self.musicHandler!.currentSong?.album?.imageColors.count != 2{
                
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
    
 
    
  
    
  
    
  

 
 
    // *** MusicHandling Section ***************************************************

    //Should be called if song changes, update song majority of time. Should eventually move this/restructure
   
    
    // Called when currentSong is changed
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
    
    //Previous Song
    @IBAction func prevSong(_ sender: Any) {
        musicHandler?.prevSong()
    }
    
    //Music pause or play
    @IBAction func changeState(_ sender: Any) {
        musicHandler?.PlayPauseMusic()
    }
    
    //Next Song
    @IBAction func nextSong(_ sender: Any) {
        musicHandler?.nextSong()
    }
    
    //Upon view dissapearing switch delegate and updateUI
    override func viewDidDisappear(_ animated: Bool) {
        musicHandler?.delegate = musicHandler?.musicBar
        musicHandler?.updateUI()
    }
    
    //Reset info if needed
    func reset(){
        musicUIController?.reset()
    }
    
    //Called from MusicHandler if state is changed, updates pause/play button, restrictions, local isPaused var used for playBack location, and updates playbackLocation value
    func updateState(state: SPTAppRemotePlayerState){
        if song.text != musicHandler?.currentSong?.title{
            updateUI(song: (musicHandler?.currentSong!)!)
        }

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
    
    
   
    // *** Playback Control Section ***************************************************
    
    //Upon begin disable gestures, set thumbnail to be large, update color. Upon end restore values changed
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                toggleGestures(allow:false)
                playbackLocation.setThumbImage(UIImage(named: "Bigger Circle"), for: UIControl.State.normal)
                playbackLocation.tintColor = (self.averageColor ?? UIColor.darkGray).inverse()
                
                
            case .ended:
                toggleGestures(allow: true)
                playbackLocation.tintColor = UIColor.darkGray
                playbackLocation.setThumbImage(UIImage(named: "Small Circle"), for: .normal)
                
            default:
                break
            }
        }
    }
    
    //Toggles pan gesture to swipe screen away
    func toggleGestures(allow: Bool){
        let gestures = view.gestureRecognizers
        var count = 0
        while(count < (gestures?.count)!){
            gestures![count].isEnabled = allow
            count += 1
        }
    }
    
    //Init playback timer and playbacklocation action
    func initTimer(){
        playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        playbackLocation.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

    }
    
    //Called every 1/10 second and updates playback location slider value match songs playback location
    @objc func updateCounting(){
        if !self.isPaused{
            playbackLocation.value += 100
        }
    }
    
    //Updates playback slider max value to match duration
    func updateSlider(){
        if let song = musicHandler?.currentSong{
            playbackLocation.maximumValue = Float(song.duration)
        }
    }
    
    // *** Volume Section ******************************************************************
    
    //Init function that calls other functions to initialize volume UI
    func addButtons(){
        volumeBackgroundView = getNoiseBackground()
        volumeButton = getNoiseButton()
        volumeSlider = getVolumeSlider()
        buttonsView.addSubview(volumeSlider)
        buttonsView.addSubview(volumeBackgroundView)
        buttonsView.addSubview(volumeButton)
        updateVolumeUI()
    }
    
    
    //Ovverides function so that upon touching anywhere should hide volume UI
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideVolume()
        super.touchesEnded(touches, with: event)
    }
    
    //Hides volume UI
    @objc func hideVolume(){
        if !scrollView.isScrollEnabled{
            volumeButton.sendActions(for: .valueChanged)
            volumeButton.setClicked(false)
        }
    }
    
    //Called upon volume slider changing. Disables/enables scrollling and updates system volume
    @objc func volumeChange(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                toggleGestures(allow:false)
                
                
            case .moved:
                print("HERE should set it?")
                MPVolumeView.setVolume(slider.value)
                break
                
            case .ended:
                toggleGestures(allow: true)
                
            default:
                break
            }
        }
    }
    
    //Does actual animating of showing or hiding volume UI
    func animateVolume(duration: TimeInterval, alpha: CGFloat){
 
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
//            self.volumeSlider.value = volume
            self.volumeBackgroundView.alpha = alpha
            self.volumeSlider.alpha = alpha
        }, completion: {
            (value: Bool) in
            
        })
    }
    
    //Function called toggle volume on/off
    @objc func toggleVolume(){
        var alpha:CGFloat = 1
        var duration = 0.5
        if volumeSlider.isSelected{
            alpha = 0
            duration = 0.2
            scrollView.isScrollEnabled = true
        }
        else{
            scrollView.isScrollEnabled = false
        }
        volumeSlider.isSelected = !volumeSlider.isSelected
        animateVolume(duration: duration, alpha: alpha)
    }
    
    //returns initalized volume button (WCLShineButton)
    func getNoiseButton() -> WCLShineButton{
        var param2 = WCLShineParams()
        param2.shineCount = 15
        param2.animDuration = 2
        param2.smallShineOffsetAngle = -5
        let tempButton = WCLShineButton(frame: .init(x: 23, y: seeMoreButton.frame.maxY - 40, width: 30, height: 30), params:param2)
        tempButton.image = .custom(UIImage(named: "lowsound")!)
        tempButton.addTarget(self, action: #selector(toggleVolume), for: .valueChanged)
        return tempButton
    }
    
    //returns initalized volume background view
    func getNoiseBackground() -> UIView{
        let tempView = UIView(frame: CGRect(x: 10, y: seeMoreButton.frame.maxY - 50, width: 50, height: 50))
        tempView.layer.cornerRadius = tempView.frame.width/2
        tempView.alpha = 0
        tempView.backgroundColor = UIColor.white
        tempView.layer.borderWidth = 4
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideVolume))
        tempView.addGestureRecognizer(tap)
        return tempView
    }
    
    //returns initalized volume slider
    func getVolumeSlider() -> VolumeSlider{
        let width = 2*seeMoreButton.frame.minX/3 - 20
        let tempSlider = VolumeSlider(frame: CGRect(x: volumeButton.center.x + 20, y: volumeButton.center.y - 10, width: width, height: 20))
        tempSlider.addTarget(self, action: #selector(volumeChange(slider:event:)), for: .valueChanged)
        let  audioSession = AVAudioSession.sharedInstance()

      

        let volume : Float = audioSession.outputVolume
  
        tempSlider.value = volume
        return tempSlider
    }
    
    //Sets colors of volume
    func updateVolumeUI(){
        let color = UIColor.black
        let color2 = UIColor.lightGray
        volumeSlider.backgroundColor = color
        volumeSlider.tintColor = color
        volumeSlider.maximumTrackTintColor = color2
        volumeBackgroundView.layer.borderColor = color.cgColor
        volumeButton.params.bigShineColor = color
        volumeButton.params.smallShineColor = color2
        volumeButton.fillColor = color
    }
    
}


