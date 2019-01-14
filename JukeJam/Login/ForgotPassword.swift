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


class ForgotPassword: BaseLoginController{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var button: loginButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeTextInput()
        self.textFields = [email]
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
   
    func customizeView(){
        self.view.backgroundColor = UIColor.black
        self.customizeClassView()
        label.textColor = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
    }
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let useColor = UIColor.stem
        email.intializeInfo(title: "Email", placeholder: "Email", color: useColor, size: 15, type: .envelope, password: false)
    }


  
//   Calls Firebase's password recovery and brings users back to login page
    @IBAction func recoverMe(_ sender: UIButton) {
        resignResponders()
        if !checkFilled(){
            return
        }
        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { error in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
                self.mainController.state = .login
                self.mainController.presentController(sender: self)

            })
        }
    }

    


}
