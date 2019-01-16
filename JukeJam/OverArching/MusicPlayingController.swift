import UIKit
import SPStorkController

class MusicPlayingController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var TabBar: ScreenController?
    var isPlaying: Bool = false
    weak var musicBar: MusicBar!
    var musicHandler: MusicHandler!
    var mainController: ControllerController!

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
            print("HERE")
            musicBar = destination
            
        }
    }
    


    override func viewDidAppear(_ animated: Bool) {
        self.TabBar?.test()
    }
    


 

}
extension MusicPlayingController: MusicBarDelegate {
    func expandSong(song: Song) {
        print("HERE whats good")
        //1.
        guard let maxiCard = storyboard?.instantiateViewController(
            withIdentifier: "MaxiSongCardViewController")
            as? MaxiSongCardViewController else {
                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
                return
        }
        
        //2.
        maxiCard.backingImage = view.makeSnapshot()
        //3.
        maxiCard.currentSong = song
        //4.
        maxiCard.sourceView = musicBar
        if let tabBar = tabBarController?.tabBar {
            maxiCard.tabBarImage = tabBar.makeSnapshot()
        }
        
        present(maxiCard, animated: false)
    }
}
