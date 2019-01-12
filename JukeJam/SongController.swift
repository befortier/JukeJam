
import UIKit
import SPStorkController

class SongController: UIViewController {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var prevSong: UIImageView!
    @IBOutlet weak var nextSong: UIImageView!
    @IBOutlet weak var state: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationCapturesStatusBarAppearance = true

    }
    

}
