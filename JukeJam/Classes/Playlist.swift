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
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                return UIImage(data: data!)!
            }
        }
        return UIImage(named: "No Music")!
    }
   
}
