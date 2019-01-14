//
//  SignUpController.swift
//  iVote
//
//  Created by Rena fortier on 11/21/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseDatabase
import GSMessages
import NVActivityIndicatorView

class SignUpController: BaseLoginController{
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var confirmPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var registerButton: loginButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    var curEmail: String = "";
    var curPassword: String = "";
    var curConfirmed: String = "";
    var curUsername: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up"
        self.customizeTextInput()
        self.textFields = [email,password,username,confirmPassword]
    }
  
    override func awakeFromNib() {
        let _ = self.view
        self.baseModal = whiteView
        self.customizeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    Does prelimary checking to make sure info is validated, then calls Firebases createUser
    @IBAction func registerAccount(_ sender: UIButton) {
        resignResponders()
        if !checkFilled() {
            return
        }
        if !validate(){
            return
        }
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (authResult, error) in
            guard let user = authResult?.user else {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        
                    case .emailAlreadyInUse:
                        self.email.errorMessage = "Email already in use"
                        break
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                return
            }
            self.startAnimate(wholeView: self.whiteView, frame: self, message: "Creating Account")
            var obj: [String:Any] = [:]
            obj["email"] = self.curEmail
            obj["username"] = self.curUsername
            self.fillUserData(Dict: obj)
            self.endAnimate(wholeView: self.whiteView, frame: self)
            self.showMessage("Account registered", type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.switchControllers(home: true)

            })
        }
    }
    
    //Validates fields: Passwords secure, emails are emails, usernames long enough
    func validate() -> Bool{
        var success: Bool = true
        let numbers = CharacterSet(charactersIn: "1234567890")
        let symbols = CharacterSet(charactersIn: "!@#$%^&*-_~`")
        if curUsername.count < 4 || curUsername.count > 45 {
            self.username.errorMessage = "Must be between 4 and 45 characters"
            success = false
        }
        if(curEmail.count < 3 || !self.email.text!.contains("@")) {
            self.email.errorMessage = "Invalid email"
            success = false
        }
        if curPassword.count < 7 {
            success = false
            self.password.errorMessage = "Must be at least 7 characters"
        }
        else if curPassword.rangeOfCharacter(from: numbers) == nil {
            success = false
            self.password.errorMessage = "Must contain a number"
        }
        else if curPassword.rangeOfCharacter(from: symbols) == nil {
            success = false
            self.password.errorMessage = "Must contain a symbol"
        }
        else if !curPassword.isValidPassword(){
            success = false
            self.password.errorMessage = "Must contain a capital"
        }
        if curPassword != curConfirmed {
            self.confirmPassword.errorMessage = "Passwords do not match"
            success = false
        }
        return success
    }
    
    
    //Customizes white view
    func customizeView(){
        customizeClassView()
        registerLabel.textColor = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.dismiss(animated: true)
        switch segue.identifier {
        case "Login":
            let DestViewController: ViewController = segue.destination as! ViewController
            DestViewController.mainController = self.mainController
            break
            
         default:
            break
        }
    }
    
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let useColor = UIColor.stem
        email.intializeInfo(title: "Email", placeholder: "Email", color: useColor, size: 15, type: .envelope, password: false)
        username.intializeInfo(title: "Username", placeholder: "Username", color: useColor, size: 15, type: .user, password: false)
        password.intializeInfo(title: "Password", placeholder: "Password", color: useColor, size: 15, type: .lock, password: true)
        confirmPassword.intializeInfo(title: "Confirm Password", placeholder: "Confirm Password", color: useColor, size: 15, type: .lock, password: true)
       
    }
    
}
extension String {
//    Used to check if password is valid with symbols, caps, and number
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{7,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
