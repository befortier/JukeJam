

import UIKit

class SongPlayControlViewController: UIViewController, SongSubscriber {

  // MARK: - IBOutlets
  @IBOutlet weak var songTitle: UILabel!
  @IBOutlet weak var songArtist: UILabel!
  @IBOutlet weak var songDuration: UILabel!
    var mainColor: UIColor!
    @IBOutlet weak var gradientFade: UIView!
    @IBOutlet weak var playbackLocation: UISlider!
    // MARK: - Properties
  var currentSong: Song? {
    didSet {
      configureFields()
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureFields()
    self.gradientFade.backgroundColor = currentSong?.imageColors[((currentSong?.imageColors.count) ?? 1) - 1]
    self.gradientFade.addFadeOut()
  }
}

// MARK: - Internal
extension SongPlayControlViewController {

  func configureFields() {
    guard songTitle != nil else {
      return
    }
    mainColor = currentSong?.imageAvColor
    songTitle.text = currentSong?.title
    songArtist.text = currentSong?.artist
    
//    songDuration.text = "Duration \(currentSong?.presentationTime ?? "")"
  }
}

// MARK: - Song Extension
extension Song {

  var presentationTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm:ss"
    let date = Date(timeIntervalSince1970: duration)
    return formatter.string(from: date)
  }
}

