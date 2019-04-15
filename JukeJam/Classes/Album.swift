import Foundation
import ChameleonFramework

class Album: NSObject{
    
    var name: String?
    var id: String?
    var imageColors: [UIColor] = []
    var imageAvColor: UIColor!
    var cover: UIImage?
    
    
    //When changing things, init albums with temporary image, go back and update them later.
    init(id: String, name: String?, cover: UIImage?){
        super.init()
        self.id = id
        self.name = name
        self.cover = cover
        self.imageAvColor = UIColor.clear
        self.imageColors = [UIColor.clear]
        self.initColors()
        
    }
    
    func initColors(){
        DispatchQueue.global().async {
        self.imageAvColor = AverageColorFromImage(self.cover!)
        self.imageColors = [self.imageAvColor]
        var colors = ColorsFromImage(self.cover!, withFlatScheme: true)
        self.imageColors = [colors[0],colors[1]]
        self.imageColors.sort(by: {$0.hue < $1.hue})
        }
    }
    
}
