import Foundation
import FBSDKLoginKit
import FacebookLogin
import FirebaseAuth

extension MusicPlayingController{
    func logout(){
        guard Auth.auth().currentUser != nil else {
            return
        }
        do {
            try Auth.auth().signOut()
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
            self.musicHandler.endSession()
            self.mainController.state = .login
            self.mainController.presentController(sender:self)
            } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
