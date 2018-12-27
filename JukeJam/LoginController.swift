//
//  ViewController.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import Firebase
import SkyFloatingLabelTextField
import FontAwesome_swift
import FirebaseDatabase
import NVActivityIndicatorView
import FBSDKCoreKit
import FBSDKLoginKit



class ViewController: UIViewController, GIDSignInUIDelegate, NVActivityIndicatorViewable {
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var googleLabel: UILabel!
    @IBOutlet weak var facebookLogo: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var googleButton: UIView!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: loginButton!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var googleLogo: UIImageView!
    @IBOutlet weak var facebookButton: UIView!
    var activitiy: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        self.navigationItem.title = "Sign In"
        self.initActivity(thisSelf: self)
        self.addBackground()
        self.customizeButtons()
        self.customizeTextInput()
        self.customizeView()
        self.addEvents()

        NotificationCenter.default.addObserver(self, selector: #selector(trigger(_:)), name: .startAnime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stop(_:)), name: .endAnime, object: nil)
    }
    
    @objc func trigger(_ sender: Notification) {
        startAnimate(wholeView: wholeView, frame: self, message: "Loading your Account")
    }
    @objc func stop(_ sender: Notification) {
        self.saveDatabase(Data: [:])
        endAnimate(wholeView: wholeView, frame: self)
    }
    //Allows UIView's to be touched and function called
    func addEvents(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.loginEmail(_:)))
        self.loginButton.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.loginFacebook(_:)))
        self.facebookButton.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.loginGoogle(_:)))
        self.googleButton.addGestureRecognizer(gesture3)
    }
    //Customizes white view
    func customizeView(){
        whiteView.backgroundColor = UIColor.white
        whiteView.clipsToBounds = true
        whiteView.layer.cornerRadius = 20.0
        whiteView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        whiteView.layer.masksToBounds = true
    }
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        let orange = UIColor.orange
        email.intializeInfo(title: "Email", placeholder: "Email", color: overcastBlueColor, size: 15, type: .envelope, password: false)
        password.intializeInfo(title: "Password", placeholder: "Password", color: orange, size: 15, type: .lock, password: true)
        email.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        password.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
    }
    
    //Customizes buttons to look nice
    func customizeButtons() {
        let fbBlue = UIColor(red: 59/255,green: 89/255,blue :152/255, alpha: 1)
        fbLabel.textColor = fbBlue
        facebookButton.layer.borderWidth = 5.0
        facebookButton.layer.cornerRadius = 20.0
        facebookButton.layer.borderColor = fbBlue.cgColor
        let googleRed = UIColor(red: 219/255,green: 50/255,blue :54/255, alpha: 1)
        googleLabel.textColor = googleRed
        googleButton.layer.borderWidth = 5.0
        googleButton.layer.cornerRadius = 20.0
        googleButton.layer.borderColor = googleRed.cgColor
        if view.frame.width < 352.5 {
            fbLabel.font = fbLabel.font.withSize(13)
            facebookLogo.frame = CGRect(x: facebookLogo.frame.minX, y: facebookLogo.frame.minY + 20, width: facebookLogo.frame.width, height: facebookLogo.frame.height - 40)
            googleLabel.font = googleLabel.font.withSize(13)
            googleLogo.frame = CGRect(x: googleLogo.frame.minX, y: googleLogo.frame.minY + 20, width: googleLogo.frame.width, height: googleLogo.frame.height - 40)
        }
    }

    //Deals with emailAuth/login
    @objc func loginEmail(_ sender: UITapGestureRecognizer) {
        var email: String = "";
        var password: String = "";

        if self.email.text != nil{
            email = self.email.text!
        }
        if self.password.text != nil{
            password = self.password.text!
        }
        
        if email == "" || password == "" {
            if email == "" {
                self.email.handleError(message: "Email is required")
            }
            if password == "" {
                self.password.handleError(message: "Password is required")
            }
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                switch errCode {
                case .wrongPassword:
                    self.password.handleError(message: "Wrong password")
                    break
                
                case .invalidEmail:
                    self.email.handleError(message: "Invalid Email")
                    break
                
                case .userNotFound:
                    self.email.handleError(message: "Email not registered")
                    break
                    
                default:
                    print("Create User Error: \(error!)")
                }
            }
                return
            }
            self.startAnimate(wholeView: self.wholeView, frame: self, message: "Loading your Account")
            self.saveLoggedState()
            self.endAnimate(wholeView: self.wholeView, frame: self)
            self.switchControllers()
        }
      
    }

//Initiates google sign in process, rest of it is handled in AppDelegate
    @objc func loginGoogle(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Handles facebook authentication
    @objc func loginFacebook(_ sender: UITapGestureRecognizer) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email, .userBirthday, .userGender, .userLocation], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.startAnimate(wholeView: self.wholeView, frame: self, message: "Loading your Account")
                self.signIntoFirebase()
                break

            case .failed( _):
                  self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your facebook account, please try again.")
                break
                
            case .cancelled:
                 // self.alertUser(title: "Cancelled authentication", message: "It appears you cancelled your Facebook authentication.")
                break
            }
        }
    }
    //Signs into Firebase
    fileprivate func signIntoFirebase(){
        guard let accessTokenString = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credential){ (user,err) in
            if err != nil{
               self.alertUser(title: "Failed to Authenticate", message: "Sorry, but we could not authenticate your account in our database, we are working to fix this")

                return
            }
            self.fillFBProfile()
            self.saveLoggedState()
            self.endAnimate(wholeView: self.wholeView, frame: self)
            self.switchControllers()
        }
        
    }
    func fillUserData(Dict: [String:Any]){
        let user: User = User(name: Dict["name"] as! String)
        user.location = Dict["location"] as? String
        user.birthday = Dict["birthday"] as? String
        user.email = Dict["email"] as? String
        user.first_name = Dict["first_name"] as? String
        user.last_name = Dict["last_name"] as? String
        user.gender = Dict["gender"] as? String
        user.id = Dict["id"] as? String
        let userData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(userData, forKey: "user")
        self.saveDatabase(Data: Dict)
    }

    func fillFBProfile(){
        let semaphore = DispatchSemaphore(value: 1)
        var temp: [String:Any] = [:]
        var counter: Int = 0
        let length = 8
        let params = ["name","first_name","last_name","location","gender","birthday","email", "id"]
        let handler: ([String:AnyObject], String?) -> Void = { data, field in
            semaphore.wait()
            temp[field!] = data[field!]
            if field == "location"{
                temp[field!] = (data["location"]?["name"])!
            }
            if field == "id"{
                temp[field!] = "F_\((data[field!])!)"
            }
            counter += 1
            if counter == length{
                self.fillUserData(Dict: temp)
            }
            semaphore.signal()
        }
        for i in 0..<length {
            self.fetchFBInfo(field: params[i], dict: temp, completionHandler: handler)
        }
    }
    func fetchFBInfo(field: String, dict: [String: Any], completionHandler: @escaping ([String:AnyObject], String?) -> Void)
    {
        let task = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": field]).start {connection,result,error in
         
                if error != nil
                {
                    print("Error: \(error)")
                }
                else
                {
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    completionHandler(data, field)
                }
            }
        }
        


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "loginBackground")
        imageViewBackground.alpha = 0.3
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
}






