import Foundation

class Album: NSObject{
    
    var name: String?
    var id: String?
    var cover: UIImage?
    
    init(id: String){
        self.id = id
    }
}
