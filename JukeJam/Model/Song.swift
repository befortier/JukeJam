
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
    
     init(title: String, duration: TimeInterval, artist: String, cover: UIImage){
        super.init()
        self.cover = cover
        self.title = title
        self.duration = duration
        self.artist = artist
        DispatchQueue.global().async {
            self.initColors()
        }
        }
    
    func initColors(){
        imageAvColor = AverageColorFromImage(self.cover!)
        imageColors = [imageAvColor]
        print("HERE SONG Half SET", imageColors.count)

        var colors = ColorsFromImage(self.cover!, withFlatScheme: true)
        imageColors = [colors[0],colors[1]]
        imageColors.sort(by: {$0.hue < $1.hue})
        print("HERE SONG FULL SET")
    }
    
   
}



