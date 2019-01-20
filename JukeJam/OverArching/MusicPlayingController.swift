import UIKit
import SPStorkController

class MusicPlayingController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var TabBar: ScreenController?
    var isPlaying: Bool = false
    weak var musicBar: MusicBar!
    var musicHandler: MusicHandler!
    var mainController: ControllerController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()

       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicBar = musicHandler.addBar(frame: self.view)
        musicBar?.delegate = self
        initMusic()

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
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScreenController,
            segue.identifier == "BeginSegue" {
            self.TabBar = vc
            vc.MusicController = self
        }
        if let destination = segue.destination as? MusicBar {
            musicBar = destination
            
        }
    }
    


    override func viewDidAppear(_ animated: Bool) {
        self.TabBar?.test()
    }
    


 

}
extension MusicPlayingController: MusicBarDelegate {
    func expandSong(song: Song) {
        if let modal: SongController = storyboard?.instantiateViewController(withIdentifier: "SongController") as? SongController {
            let transitionDelegate = SPStorkTransitioningDelegate()
            transitionDelegate.isSwipeToDismissEnabled = true
            transitionDelegate.isTapAroundToDismissEnabled = true
            print("HERE should present1")
            modal.transitioningDelegate = transitionDelegate
            modal.modalPresentationStyle = .custom
            modal.currentSong = song
            modal.musicHandler = self.musicHandler
            print("HERE should present2")
            present(modal, animated: true, completion: nil)
        }

}
}
