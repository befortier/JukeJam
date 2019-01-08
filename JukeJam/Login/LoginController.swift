//
//  ViewController.swift
//  iVote
//
//  Created by Rena fortier on 11/19/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

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



class ViewController: UIViewController, GIDSignInUIDelegate, NVActivityIndicatorViewable, UITextFieldDelegate {
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
        email.delegate = self
        password.delegate = self
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When google starts to sign in
    @objc func trigger(_ sender: Notification) {
        startAnimate(wholeView: wholeView, frame: self, message: "Loading your Account")
    
    }
    
    //After google and firebase has succesfully authenticated
    @objc func stop(_ sender: Notification) {
        let obj = sender.userInfo
        var Dict: [String: Any] = [:]
        Dict["name"] = obj?["name"]
        Dict["first_name"] = obj?["first_name"]
        Dict["last_name"] = obj?["last_name"]
        Dict["G_id"] = obj?["id"]
        Dict["email"] = obj?["email"]
        fillUserData(Dict: Dict)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
   @objc func dismissKeyboard (_ sender: Any) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
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
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
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
            self.endAnimate(wholeView: self.wholeView, frame: self)
            self.switchControllers(home: true)
        }
      
    }

//Initiates google sign in process, rest of it is handled in AppDelegate
    @objc func loginGoogle(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Handles facebook authentication
    @objc func loginFacebook(_ sender: UITapGestureRecognizer) {
       loginFB()
    }

    
    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "loginBackground")
        imageViewBackground.alpha = 0.3
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
}






