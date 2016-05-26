//
//  LoginViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        let email = self.emailField.text
        let password = self.passwordField.text
        let isFormValid = validateLoginForm(email!, password: password!)
        if isFormValid {
            authenticateUser(email!, password: password!)
        }
    }
    
    func authenticateUser(email: String, password: String) {
        let spinnerFrame: UIView = self.view.startASpinner()
        let parameters = ["email": email, "password": password]
        Alamofire.request(
            .POST,
            "http://routeme-api.us-east-1.elasticbeanstalk.com/api/users/login",
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.view.stopSpinner(spinnerFrame)
                switch response.result {
                    case .Success(let JSON):
                        let HTTP_STATUS_CODE_FOUND: Int = 302
                        let statusCode = (response.response?.statusCode)!
                        let responseJSON = JSON as! NSDictionary
                        if (statusCode == HTTP_STATUS_CODE_FOUND) {
                            let loggedInId = responseJSON["id"] as! String
                            let loggedInUsername = responseJSON["username"] as! String
                            let loggedInEmail = responseJSON["email"] as! String
                            let user = User(id: loggedInId, username: loggedInUsername, email: loggedInEmail)
                            Helper.loginUser(user, viewController: self)
                        } else {
                            Helper.alertRequestError(responseJSON, viewController: self)
                    }
                    case .Failure(let error):
                        self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }

    
    func validateLoginForm(email: String, password: String) -> Bool {
        let isValidEmail = Helper.validateEmail(email)
        let isValidPassword = Helper.validatePassword(password)
        if !isValidEmail {
            alert("E-mail", message: "Please enter a valid e-mail address.", buttonText: "OK")
            return false
        } else if !isValidPassword {
            alert("Password", message: "Password must be greater than 1 character", buttonText: "OK")
            return false
        }
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.addBackground(Image.Background.Login)
        
        
        setTextFieldDelegates()
        setTextFieldsBottomBorders()
        
        // Do any additional setup after loading the view.
    }
    
    func setTextFieldDelegates() {
        // textfields' tags are defined in the storyboard
        emailField.delegate = self // tag 0
        passwordField.delegate = self // tag 1
    }
    
    func setTextFieldsBottomBorders() {
        Helper.setTextFieldBottomBorder(emailField)
        Helper.setTextFieldBottomBorder(passwordField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
