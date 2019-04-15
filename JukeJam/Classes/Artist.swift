import Foundation
class Artist: NSObject{
    
    var name: String?
    var id: String?
    
    init(id: String,name: String){
        self.id = id
        self.name = name
    }
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(id: id, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    
}
