
import UIKit
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView
import SkyFloatingLabelTextField
import FontAwesome_swift
var blurEffectView: UIVisualEffectView?

extension UIViewController  {
    func my_test(){
        print("Test")
    }
    
    //Switches from LoginController to HomeController
     func switchControllers(){
        let def = UserDefaults.standard
        let val = def.bool(forKey: "visited")
        if val != false{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? HomeController
            {
                present(vc, animated: true, completion: nil)
            }
        }
        else{
            def.set(true, forKey: "visited")
            let vc = WelcomeController()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    //Stores UserDefault data (is_authenticated,id)
    func saveLoggedState() {
        let userID = Auth.auth().currentUser!.uid
        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated")
        def.set(userID, forKey: "id")
        def.synchronize()
    }
    
    //Checks to see if info is stored in DB, else saves it.
     func saveDatabase(){
        
        let data: [String: String] = ["username": "Tset"]
        let userID = Auth.auth().currentUser?.uid
        print("UID \(userID)")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
            }else{
                ref.child("users").child(userID!).setValue(data)
            }
        })
    }
    
    @objc func checkReset(sender: SkyFloatingLabelTextFieldWithIcon){
        if sender.text != ""{
            sender.errorMessage = ""
        }
        
    }
    
    func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
 
 
    
}
extension SkyFloatingLabelTextFieldWithIcon{
    func animateField(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    func handleError(message: String){
        self.animateField()
        self.errorMessage = message
    }
    
    func intializeInfo(title: String, placeholder: String, color: UIColor, size: CGFloat, type: FontAwesome, password: Bool){
        self.placeholder = placeholder
        self.title = title
        self.tintColor = color
        self.selectedTitleColor = color
        self.selectedLineColor = color
        self.selectedIconColor = color
        self.isSecureTextEntry = password
        self.iconFont = UIFont.fontAwesome(ofSize: size, style: .solid)
        self.iconText = String.fontAwesomeIcon(name: type)
        self.errorColor = UIColor.red
    }
    

}
extension NVActivityIndicatorViewable{

    
    func initActivity(thisSelf: UIViewController){
        let color = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = UIColor.white
        NVActivityIndicatorView.DEFAULT_COLOR = color
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = thisSelf.view.frame
    }
    
    func startAnimate( wholeView: UIView, frame: UIViewController, message: String){
        if let temp = frame as? SignUpController {
            temp.startAnimating(CGSize.init(width: frame.view.frame.width/2, height: frame.view.frame.height/2), message: message, type: .orbit)
        }
        else if let temp2 = frame as? ViewController {
            temp2.startAnimating(CGSize.init(width: frame.view.frame.width/2, height: frame.view.frame.height/2), message: message, type: .orbit)
        }
        wholeView.tintColor = UIColor.lightGray
        frame.view.insertSubview(blurEffectView!, at: 1)
        frame.view.insertSubview(blurEffectView!, at: 2)
        frame.view.insertSubview(blurEffectView!, at: 3)
    }
    
    func endAnimate(wholeView: UIView, frame: UIViewController){
        blurEffectView?.removeFromSuperview()
        wholeView.tintColor = nil
        if let temp = frame as? SignUpController {
            temp.stopAnimating()
        }
        else if let temp2 = frame as? ViewController {
            temp2.stopAnimating()
        }
      
    }
}

extension Notification.Name {
    public static let startAnime = Notification.Name("startAnime")
    public static let endAnime = Notification.Name("endAnime")
}
