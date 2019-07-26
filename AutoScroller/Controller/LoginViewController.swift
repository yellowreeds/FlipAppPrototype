//
//  LoginViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 12/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Toast_Swift

class LoginViewController: UIViewController {
    
    //MARK: - HOLD JSON
    var userJSON: JSON?
    
    //MARK: - INIT REALM
    let realm = try! Realm()
    
    //MARK: - IBOUTLET
    // MARK: Label
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // MARK: ButtonLabel
    @IBOutlet weak var alreadyHaveAccountButtonLabel: UIButton!
    @IBOutlet weak var loginButtonLabel: UIButton!
    @IBOutlet weak var registerButtonLabel: UIButton!
    
    // MARK: TextField
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    // MARK: - LOGIN STATUS
    var status = false
    var register = true
    var credentialStatus = false
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide element
        nameField.isHidden = true
        phoneNumberField.isHidden = true
        nameLabel.isHidden = true
        phoneNumberLabel.isHidden = true
        alreadyHaveAccountButtonLabel.isHidden = true
        
    }
    
    // MARK: - VALIDATE EMAIL
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    // MARK: - VALIDATE NUMBER
    func isValidNumber(value: String) -> Bool {
        let phoneRegEx = "^[0-9]{9,12}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    // MARK: - REGISTER USER
    func registerUser(username: String, email: String, phone: String, password: String) {
        let url = "https://amentiferous-grass.000webhostapp.com/api/auth/signup"
        
        let parameters: Parameters = ["fliptoken" : "flip123", "user_name" : username, "user_email" : email, "user_phone" : phone, "user_password" : password]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Sukses! \(JSON(response.result.value!))")
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    // MARK: - LOGIN USER
    func loginUser(email: String, password: String) {
        let url = "https://amentiferous-grass.000webhostapp.com/api/auth/login"
        
        let parameters: Parameters = ["fliptoken" : "flip123", "user_email" : email, "user_password" : password]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                self.userJSON = JSON(response.result.value!)
                if "\(self.userJSON!["status"])" == "false" {
                    self.credentialStatus = false
                } else if "\(self.userJSON!["status"])" == "true" {
                    self.credentialStatus = true
                }
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    // MARK: - SHOW/HIDE ELEMENT
    func elementSettingLogin(condition: Bool) {
        passwordField.isHidden = condition
        emailField.isHidden = condition
        passwordLabel.isHidden = condition
        emailLabel.isHidden = condition
    }
    
    // MARK: - LOGIN BUTTON PRESSED
    @IBAction func loginButtonPressed(_ sender: Any) {
        alreadyHaveAccountButtonLabel.isHidden = true
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            // if email and password empty
            // create alert
            let alert = UIAlertController(title: "Please fill the form!", message: "Please fill the form to continue", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            if status == false {
                // if user no login
                let vc = self.navigationController?.viewControllers[0] as! AccountViewController
                vc.status = true
                loginUser(email: emailField.text!, password: passwordField.text!)
                self.view.makeToastActivity(.center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    if self.credentialStatus {
                        //if everything valid
                        do {
                            try self.realm.write {
                                let newItem = Account()
                                newItem.userID = "\(self.userJSON!["data"]["user_id"])"
                                newItem.username = "\(self.userJSON!["data"]["user_email"])"
                                newItem.fullName = "\(self.userJSON!["data"]["user_name"])"
                                newItem.avatar = "\(self.userJSON!["data"]["user_avatar"])"
                                self.realm.add(newItem)
                            }
                        } catch {
                            print("Error write realm, \(error)")
                        }
                        self.status = true
                        self.view.hideToastActivity()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // if everything does not valid
                        self.view.hideToastActivity()
                        
                        // create the alert
                        let alert = UIAlertController(title: "Incorrect Credentials", message: "Your password/login is invalid", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    // MARK: - REGISTER BUTTON
    @IBAction func registerButtonPressed(_ sender: Any) {
        // show element
        nameField.isHidden = false
        phoneNumberField.isHidden = false
        nameLabel.isHidden = false
        phoneNumberLabel.isHidden = false
        alreadyHaveAccountButtonLabel.isHidden = false
        loginButtonLabel.isHidden = true
        
        if nameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty || phoneNumberField.text!.isEmpty {
            // if field empty
            
            // create the alert
            let alert = UIAlertController(title: "Please fill the form!", message: "Please fill the form to continue", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            // if field is not empty
            if isValidNumber(value: phoneNumberField.text!) && isValidEmail(testStr: emailField.text!) {
                // if email and phone number correct
                registerUser(username: nameField.text!, email: emailField.text!, phone: phoneNumberField.text!, password: passwordField.text!)
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    // Put your code which should be executed with a delay here
                    self.view.hideToastActivity()
                    self.loginButtonLabel.isHidden = false
                    self.nameField.isHidden = true
                    self.phoneNumberField.isHidden = true
                    self.nameLabel.isHidden = true
                    self.phoneNumberLabel.isHidden = true
                    self.alreadyHaveAccountButtonLabel.isHidden = true
                })
            } else {
                // create the alert
                let alert = UIAlertController(title: "Not Valid", message: "Email / Phone number is not in valid form", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - ALREADY HAVE ACCOUNT
    @IBAction func alreadyHaveAccountButtonPressed(_ sender: Any) {
        loginButtonLabel.isHidden = false
        nameField.isHidden = true
        phoneNumberField.isHidden = true
        nameLabel.isHidden = true
        phoneNumberLabel.isHidden = true
        alreadyHaveAccountButtonLabel.isHidden = true
    }
}
