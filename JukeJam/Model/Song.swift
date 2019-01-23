
import UIKit
import ChameleonFramework

class Song: NSObject {

  // MARK: - Properties
    var title: String?
    var duration: Int = 0
    var artist: [Artist]?
    var cover: UIImage?
    var imageColors: [UIColor] = []
    var imageAvColor: UIColor!
    var album: Album?{
        didSet{
            cover = album?.cover
            DispatchQueue.global().async {
                self.initColors()
            }
        }
    }

    init(title: String, duration: Int, artist: [Artist], cover: UIImage, album: Album){
        super.init()
        self.cover = cover
        DispatchQueue.global().async {
            self.initColors()
        }
        self.title = title
        self.duration = duration
        self.artist = artist
        self.album = album
        }
    
    func initColors(){
        imageAvColor = AverageColorFromImage(self.cover!)
        imageColors = [imageAvColor]
        var colors = ColorsFromImage(self.cover!, withFlatScheme: true)
        imageColors = [colors[0],colors[1]]
        imageColors.sort(by: {$0.hue < $1.hue})
    }
    
   
}



