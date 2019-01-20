
import UIKit
import ChameleonFramework

class Song: NSObject {

  // MARK: - Properties
    var title: String?
    var duration: TimeInterval = 0
    var artist: String?
    var cover: UIImage?
    var imageColors: [UIColor] = []
    var imageAvColor: UIColor!
    var album: String?

    init(title: String, duration: TimeInterval, artist: String, cover: UIImage, album: String){
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



