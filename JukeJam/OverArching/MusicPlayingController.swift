import UIKit
import SPStorkController

class MusicPlayingController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var TabBar: ScreenController?
    var isPlaying: Bool = false
    weak var musicBar: MusicBar!
    var spotifyHandler: SpotifyHandler = SpotifyHandler()
    override func loadView() {
        super.loadView()
        
        let musicBar = MusicBar()
        self.view.addSubview(musicBar)
        NSLayoutConstraint.activate([
            musicBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            musicBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            musicBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            musicBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        self.musicBar = musicBar
        self.musicBar.frame = CGRect(x: -2, y: self.view.frame.height - 115, width: self.view.frame.width + 4, height: 66)
        print("HERE isset?", self.musicBar)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initMusic()
        addGestures()
        self.musicBar.songText = "Started From the Bottom Now We're Here"
        self.musicBar.coverImage = UIImage(named: "album2")
        self.musicBar.stateImage = UIImage(named: "play")


    }

    
    //Init isPlaying and either show or hide the MusicBar
    func initMusic(){
        isPlaying = isMusicPlaying()
        if isPlaying {
            musicBar.isHidden = false
        }
        else{
            musicBar.isHidden = true
        }
    }
    
    
    //Use spotifySDK and Apple music to check if anything is playing.
    func isMusicPlaying() -> Bool{
        return true
    }
    func addGestures(){
        let stateChange = UITapGestureRecognizer(target: self, action:  #selector(self.changeState))
        self.musicBar.state.addGestureRecognizer(stateChange)
    }
//
    @objc func changeState(){
        print("HERE")
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScreenController,
            segue.identifier == "BeginSegue" {
            self.TabBar = vc
            
            vc.MusicController = self
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.TabBar?.test()
    }
    


 

}
