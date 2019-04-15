
import UIKit

class Song: NSObject {

  // MARK: - Properties
    var id: String?
    var title: String?
    var duration: Int = 0
    var artist: [Artist]?
    var album: Album?

    init(id: String, title: String, duration: Int, artist: [Artist], album: Album){
        super.init()
        self.album = album
        self.id = id
        self.title = title
        self.duration = duration
        self.artist = artist
        }
    
    required convenience init(coder aDecoder: NSCoder) {
        let duration = aDecoder.decodeInteger(forKey: "duration")
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let album = aDecoder.decodeObject(forKey: "album") as! Album
        let artist = aDecoder.decodeObject(forKey: "artist") as! [Artist]
        self.init(id: id, title: title, duration: duration, artist: artist, album: album)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(artist, forKey: "artist")
        aCoder.encode(album, forKey: "album")
    }
    

   
}



