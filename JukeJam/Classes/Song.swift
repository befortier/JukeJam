
import UIKit
import ChameleonFramework

class Song: NSObject {

  // MARK: - Properties
    var id: String?
    var title: String?
    var duration: Int = 0
    var artist: [Artist]?
    var imageColors: [UIColor] = []
    var imageAvColor: UIColor!
    var album: Album?{
        didSet{
            DispatchQueue.global().async {
                self.initColors()
            }
        }
    }

    init(id: String, title: String, duration: Int, artist: [Artist], album: Album){
        super.init()
        self.album = album
        DispatchQueue.global().async {
            self.initColors()
        }
        self.id = id
        self.title = title
        self.duration = duration
        self.artist = artist
        }
    
    func initColors(){
       
        imageAvColor = AverageColorFromImage(self.album!.cover!)
        imageColors = [imageAvColor]
        var colors = ColorsFromImage(self.album!.cover!, withFlatScheme: true)
        imageColors = [colors[0],colors[1]]
        imageColors.sort(by: {$0.hue < $1.hue})
    }
    
   
}



