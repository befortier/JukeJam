import UIKit
import ChameleonFramework

class MaxiSongCardViewController: UIViewController, SongSubscriber {
  weak var sourceView: MaxiPlayerSourceProtocol!
  let cardCornerRadius: CGFloat = 10
  var currentSong: Song?
  let primaryDuration = 0.25 //set to 0.5 when ready
  let backingImageEdgeInset: CGFloat = 15.0
  var tabBarImage: UIImage?
  @IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomSectionImageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stretchySkirt: UIView!
  @IBOutlet weak var coverImageContainer: UIView!
  @IBOutlet weak var coverArtImage: UIImageView!
  @IBOutlet weak var dismissChevron: UIButton!
  @IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
  var backingImage: UIImage?
  @IBOutlet weak var backingImageView: UIImageView!
  @IBOutlet weak var dimmerLayer: UIView!
  @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
  @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
  @IBOutlet weak var coverImageLeading: NSLayoutConstraint!
  @IBOutlet weak var coverImageTop: NSLayoutConstraint!
  @IBOutlet weak var coverImageBottom: NSLayoutConstraint!
  @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
  @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
    var coverImage: UIImage!
    var songText: String!
    var moreText: String!
    @IBOutlet weak var ContainerView: UIView!
    
    
  // MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()

    modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
    modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
  }
   
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var newVc: SongPlayControlViewController?
        let containerSegueName = "SongControllerSegue"
        if segue.identifier == containerSegueName {
            newVc = segue.destination as? SongPlayControlViewController
            newVc?.currentSong = currentSong
        }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    backingImageView.image = backingImage

    scrollView.contentInsetAdjustmentBehavior = .never //dont let Safe Area insets affect the scroll view
    coverImageContainer.layer.cornerRadius = cardCornerRadius
    coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    self.modalPresentationCapturesStatusBarAppearance = true
//    coverArtImage.image = coverImage
//    song.text = songText
//    more.text = "This is a giant test - to see if the text will eventualy wrap around"
    
    
    }
    
    
    
   
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureAnimations()
    




  }
  

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initAnimations()
    self.coverImageContainer.assignImageGradientColor(colors: (self.currentSong?.imageColors)!)
  
  }


}

