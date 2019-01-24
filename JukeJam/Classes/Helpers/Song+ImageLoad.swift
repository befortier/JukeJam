//
//import UIKit
//
//extension Song {
//
//  func loadSongImage(completion: @escaping ((UIImage?) -> (Void))) {
//    guard let imageURL = coverArtURL,
//      let file = Bundle.main.path(forResource: imageURL.absoluteString, ofType:"jpg") else {
//        return
//    }
//    
//    DispatchQueue.global(qos: .background).async {
//      let image = UIImage(contentsOfFile: file)
//      DispatchQueue.main.async {
//        completion(image)
//      }
//    }
//  }
//}
