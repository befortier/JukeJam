
import UIKit
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView
import SkyFloatingLabelTextField
import FontAwesome_swift
var blurEffectView: UIVisualEffectView?

extension UIViewController  {
    
    //Switches from current controller to HomeController
    func switchControllers(home: Bool){
        let def = UserDefaults.standard
        if home{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? HomeController
            {
                present(vc, animated: true, completion: nil)
            }
        }
        else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmController") as? ConfirmController
            {
                present(vc, animated: true, completion: nil)
            }
            
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
    func saveDatabase(Data: [String: Any]){
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                ref.child("users").child(userID!).updateChildValues(Data)
            }else{
                ref.child("users").child(userID!).setValue(Data)
            }
        })
    }
    
    //Function that checks to see if a skyfloatinglabeltext field has changed values, if the value changes to have something remove error message
    @objc func checkReset(sender: SkyFloatingLabelTextFieldWithIcon){
        if sender.text != ""{
            sender.errorMessage = ""
        }
    }
// Used to alert users of a message usually error
    func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
 
 
    
}
extension SkyFloatingLabelTextFieldWithIcon{
//    Animates a skyfloatingtextfield to shake
    func animateField(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
//    Shakes the field and sets error message
    func handleError(message: String){
        self.animateField()
        self.errorMessage = message
    }
    
//    Intializes text field
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
        self.iconMarginBottom = -1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        self.iconMarginLeft = 2.0
    }
    

}
extension NVActivityIndicatorViewable{

//    Creates the loading effect
    func initActivity(thisSelf: UIViewController){
        let color = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = UIColor.white
        NVActivityIndicatorView.DEFAULT_COLOR = color
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = thisSelf.view.frame
    }
//    Starts the loading effect + blurs background
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
// Unblurs background + ends loading effect
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
