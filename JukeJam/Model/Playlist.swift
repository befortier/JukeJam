import Foundation
import Spartan

class Playlist: NSObject{
    
    var cover: UIImage?
    var name: String?
    var about: String?
    var created: String?
    var tracks: [Song] = []
    var owner: PublicUser?
    var followers: Int?
    var id: String?
    
    init(id: String){
        self.id = id
    }
    
}

extension String {
    func toImage() -> UIImage{
        let url = URL(string: self)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
       return UIImage(data: data!)!
    }
   
}
