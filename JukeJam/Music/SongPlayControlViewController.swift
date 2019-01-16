

import UIKit

class SongPlayControlViewController: UIViewController, SongSubscriber {

  // MARK: - IBOutlets
  @IBOutlet weak var songTitle: UILabel!
  @IBOutlet weak var songArtist: UILabel!
  @IBOutlet weak var songDuration: UILabel!

    @IBOutlet weak var gradientFade: UIView!
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
  self.gradientFade.assignImageGradientColor(colors: (self.currentSong?.imageColors)!)
    self.gradientFade.addFadeOut()
  }
}

// MARK: - Internal
extension SongPlayControlViewController {

  func configureFields() {
    guard songTitle != nil else {
      return
    }
    
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

