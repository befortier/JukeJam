//
//import UIKit
//
//protocol MiniPlayerDelegate: class {
//  func expandSong(song: Song)
//}
//
//class MiniPlayerViewController: UIViewController, SongSubscriber {
//
//  // MARK: - Properties
//  var currentSong: Song?
//  weak var delegate: MiniPlayerDelegate?
//
//  // MARK: - IBOutlets
//  @IBOutlet weak var thumbImage: UIImageView!
//  @IBOutlet weak var songTitle: UILabel!
//  @IBOutlet weak var playButton: UIButton!
//  @IBOutlet weak var ffButton: UIButton!
//
//  // MARK: - View Life Cycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    configure(song: nil)
//  }
//}
//
//// MARK: - Internal
//extension MiniPlayerViewController {
//
//  func configure(song: Song?) {
//    if let song = song {
//      songTitle.text = song.title
//      song.loadSongImage { [weak self] image in
//        self?.thumbImage.image = image
//      }
//    } else {
//      songTitle.text = nil
//      thumbImage.image = nil
//    }
//    currentSong = song
//  }
//}
//
//// MARK: - IBActions
//extension MiniPlayerViewController {
//
//  @IBAction func tapGesture(_ sender: Any) {
//    guard let song = currentSong else {
//      return
//    }
//
//    delegate?.expandSong(song: song)
//  }
//}
//extension MiniPlayerViewController: MaxiPlayerSourceProtocol {
//  var originatingFrameInWindow: CGRect {
//    let windowRect = view.convert(view.frame, to: nil)
//    return windowRect
//  }
//  
//  var originatingCoverImageView: UIImageView {
//    return thumbImage
//  }
//}
