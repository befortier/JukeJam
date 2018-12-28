//
//  ConfirmController.swift
//  JukeJam
//
//  Created by Rena fortier on 12/27/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ConfirmController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var confirm: loginButton!
    @IBOutlet weak var hometown: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var birthday: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var first_name: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var last_name: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var profPic: UIImageView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeView()
        self.customizeTextInput()
        updateText(user: loadInfo())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func updateText(user: User){
        email.text = user.email
        hometown.text = user.location
        username.text = user.username
        first_name.text = user.first_name
        last_name.text = user.last_name
        birthday.text = user.birthday
    }
    
    func customizeView(){
        scrollView.backgroundColor = UIColor.white
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 20.0
        topLabel.textColor = UIColor(red: 159/255,green: 90/255,blue :253/255, alpha: 1)
    }
    //Customizes text input boxes to look nice
    func customizeTextInput(){
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        email.intializeInfo(title: "Email", placeholder: "Email", color: overcastBlueColor, size: 15, type: .envelope, password: false)
        email.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        hometown.intializeInfo(title: "Hometown", placeholder: "Hometown", color: overcastBlueColor, size: 15, type: .locationArrow, password: false)
        hometown.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        birthday.intializeInfo(title: "Birthday", placeholder: "Birthday", color: overcastBlueColor, size: 15, type: .birthdayCake, password: false)
        birthday.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        username.intializeInfo(title: "Username", placeholder: "Username", color: overcastBlueColor, size: 15, type: .userTag, password: false)
        username.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        first_name.intializeInfo(title: "First Name", placeholder: "First Name", color: overcastBlueColor, size: 15, type: .addressCard, password: false)
        first_name.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
        last_name.intializeInfo(title: "Last Name", placeholder: "Last Name", color: overcastBlueColor, size: 15, type: .addressCard, password: false)
        last_name.addTarget(self, action: #selector(checkReset(sender:)), for: .editingChanged)
    }
    
    @IBAction func dp(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
  @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthday.text = dateFormatter.string(from: sender.date)
    }
    
    //Takes the values of the fields and updates profile by ID
    @IBAction func confirmed(_ sender: loginButton) {
        var obj: [String: Any] = [:]
        obj["username"] = username.text
        obj["email"] = email.text
        obj["first_name"] = first_name.text
        obj["last_name"] = last_name.text
        obj["birthday"] = birthday.text
        obj["location"] = hometown.text
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                ref.child("users").child(userID!).updateChildValues(obj)
            self.localSwitch()
        })
    }
    func localSwitch(){
                    let vc = WelcomeController()
                    present(vc, animated: true, completion: nil)
    }
}
