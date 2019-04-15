import Foundation
import Spartan

class Playlist: NSObject{
    
    var id: String?
    var cover: UIImage?
    var name: String?
    var about: String?
//    var created: String?
    var tracks: [Song] = []
    var owner: PublicUser?
    var followers: Int?
    
    init(id: String, followers: Int, owner: PublicUser, tracks: [Song], about: String, name: String){
        self.id = id
        self.followers = followers
        self.owner = owner
        self.tracks = tracks
//        self.created = created
        self.about = about
        self.name = name
    }
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let cover = aDecoder.decodeObject(forKey: "cover") as! UIImage
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let about = aDecoder.decodeObject(forKey: "about") as! String
//        let created = aDecoder.decodeObject(forKey: "created") as! String
        let tracks = aDecoder.decodeObject(forKey: "tracks") as! [Song]
        let owner = aDecoder.decodeObject(forKey: "owner") as! PublicUser
        let followers = aDecoder.decodeInteger(forKey: "followers")
        self.init(id: id, followers: followers, owner: owner, tracks: tracks, about: about, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(cover, forKey: "cover")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(about, forKey: "about")
//        aCoder.encode(created, forKey: "about")
        aCoder.encode(tracks, forKey: "tracks")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(followers, forKey: "followers")
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
