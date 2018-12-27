//
//  ForgotPassword.swift
//  iVote
//
//  Created by Rena fortier on 12/23/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase


class ForgotPassword: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var button: loginButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeTextInput()
        self.customizeView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeView(){
        self.view.backgroundColor = UIColor.black
        whiteView.backgroundColor = UIColor.white
        whiteView.clipsToBounds = true
        whiteView.layer.cornerRadius = 20.0
        label.textColor = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
    }
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        email.intializeInfo(title: "Email", placeholder: "Email", color: overcastBlueColor, size: 15, type: .envelope, password: false)
        email.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
    }


  
//   Calls Firebase's password recovery and brings users back to login page
    @IBAction func recoverMe(_ sender: UIButton) {
        var email: String = "";
        
        if self.email.text != nil{
            email = self.email.text!
        }
        if email == ""{
            self.email.handleError(message: "Email is required")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        
                    case .invalidEmail:
                        self.email.handleError(message: "Invalid email")
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
            self.showMessage("Email sent", type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? ViewController
                {
                    self.present(vc, animated: true, completion: nil)
                }            })
        }
    }

    


}
