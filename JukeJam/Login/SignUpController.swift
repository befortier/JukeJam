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

class SignUpController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
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
        self.customizeView()
        email.delegate = self
        password.delegate = self
        username.delegate = self
        confirmPassword.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard (_ sender: Any) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.confirmPassword.resignFirstResponder()
        self.username.resignFirstResponder()
    }
    
//    Does prelimary checking to make sure info is validated, then calls Firebases createUser
    @IBAction func registerAccount(_ sender: UIButton) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.confirmPassword.resignFirstResponder()
        self.username.resignFirstResponder()
        if !checkFilled() {
            return
        }
        if !validate(){
            return
        }
        Auth.auth().createUser(withEmail: curEmail, password: curPassword) { (authResult, error) in
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
                self.switchControllers(home: false)
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
    
//    Checks to make sure all fields are filled out
    func checkFilled() -> Bool{
        var success: Bool = true;
        if self.username.text != nil{
            curUsername = self.username.text!
        }
        if self.email.text != nil{
            curEmail = self.email.text!
        }
        if self.password.text != nil{
            curPassword = self.password.text!
        }
        if self.confirmPassword.text != nil{
            curConfirmed = self.confirmPassword.text!
        }
        if curUsername == ""{
            self.username.handleError(message: "Username is required")
            success = false
        }
        if curEmail == ""{
            self.email.handleError(message: "Email is required")
            success = false
        }
        if curPassword == ""{
            self.password.handleError(message: "Password is required")
            success = false
        }
        if curConfirmed == ""{
            self.confirmPassword.handleError(message: "Confirmation is required")
            success = false
        }
        return success
    }
    
    //Customizes white view
    func customizeView(){
        self.view.backgroundColor = UIColor.black
        whiteView.backgroundColor = UIColor.white
        whiteView.clipsToBounds = true
        whiteView.layer.cornerRadius = 20.0
        registerLabel.textColor = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
    }
    
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        let orange = UIColor.orange
        let green = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0)
        let red = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1.0)
        email.intializeInfo(title: "Email", placeholder: "Email", color: overcastBlueColor, size: 15, type: .envelope, password: false)
        username.intializeInfo(title: "Username", placeholder: "Username", color: green, size: 15, type: .user, password: false)
        password.intializeInfo(title: "Password", placeholder: "Password", color: orange, size: 15, type: .lock, password: true)
        confirmPassword.intializeInfo(title: "Confirm Password", placeholder: "Confirm Password", color: red, size: 15, type: .lock, password: true)
        email.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        password.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        username.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        confirmPassword.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
    }
    
}
extension String {
//    Used to check if password is valid with symbols, caps, and number
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{7,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
