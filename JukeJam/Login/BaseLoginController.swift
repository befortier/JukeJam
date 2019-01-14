import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import SkyFloatingLabelTextField
import FontAwesome_swift
import FirebaseDatabase
import NVActivityIndicatorView
import FBSDKCoreKit
import FBSDKLoginKit

class BaseLoginController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
    var textFields: [SkyFloatingLabelTextFieldWithIcon] = [] {
        didSet{
            initDelegates()
        }
    }
    var baseModal: UIView!
    var mainController: ControllerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
  
    func customizeClassView(){
        self.baseModal.backgroundColor = UIColor.white
        self.baseModal.clipsToBounds = true
        self.baseModal.layer.cornerRadius = 20.0
    }
    
    @objc func dismissKeyboard (_ sender: Any) {
       resignResponders()
    }
    
    func resignResponders(){
        var count = 0
        while count < textFields.count {
            textFields[count].resignFirstResponder()
            count += 1
        }
    }
    
    //Function that checks to see if a skyfloatinglabeltext field has changed values, if the value changes to have something remove error message
    @objc func checkReset(sender: SkyFloatingLabelTextFieldWithIcon){
        if sender.text != ""{
            sender.errorMessage = ""
        }
    }
    
    func checkFilled() -> Bool{
        var count = 0
        var success: Bool = true
        while count < textFields.count {
            var temp = ""
            if textFields[count].text != nil{
                temp = textFields[count].text!
            }
            else {
                success = false
            }
            if temp == "" {
                textFields[count].handleError(message: "Field is required")
                success = false
            }
            count += 1
        }
        return success
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initDelegates(){
        var count = 0
        while count < textFields.count {
            textFields[count].delegate = self
            textFields[count].addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
            count += 1
        }
    }
    
    //    Switches from current controller to HomeController
    func switchControllers(home: Bool){
        print("HERE Switching to home", home)
        if home{
            self.mainController.state = .app
        }
        else{
            self.mainController.state = .newUser
        }
        self.endAnimate(wholeView: self.view, frame: self)
        self.mainController.presentController(sender: self)

    }
    
    //Takes in a Dict and creates a UserDefault user, calls saveDatabase(dict)
    func fillUserData(Dict: [String:Any]){
        let user: User = User(name: "")
        user.name = Dict["name"] as? String ?? ""
        user.location = Dict["location"] as? String ?? ""
        user.birthday = Dict["birthday"] as? String ?? ""
        user.email = Dict["email"] as? String ?? ""
        user.first_name = Dict["first_name"] as? String ?? ""
        user.last_name = Dict["last_name"] as? String ?? ""
        user.gender = Dict["gender"] as? String ?? ""
        user.F_id = Dict["F_id"] as? String ?? ""
        user.G_id = Dict["G_id"] as? String ?? ""
        user.username = Dict["username"] as? String ?? ""
        let userData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(userData, forKey: "user")
        self.saveDatabase(Data: Dict)
    }
    
    //    Checks to see if info is stored in DB, else saves it.
    func saveDatabase(Data: [String: Any]){
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                ref.child("users").child(userID!).updateChildValues(Data)
                self.switchControllers(home:true)
            }
            else{
                ref.child("users").child(userID!).setValue(Data)
                self.switchControllers(home: false)
                
            }
        })
    }


}
