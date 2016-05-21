//
//  SignUpViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!


    @IBAction func signUpAction(sender: AnyObject) {
        let email = self.emailField.text
        let username = self.usernameField.text
        let password = self.passwordField.text
        let confirmPassword = self.confirmPasswordField.text
        
        let isFormValid = validateSignUpForm(email!, username: username!, password: password!, confirmPassword: confirmPassword!)
        if isFormValid {
            createUserRequest(email!, username: username!, password: password!, confirmPassword: confirmPassword!)
        }
    }

    
    func validateSignUpForm(email: String, username: String, password: String, confirmPassword: String) -> Bool {
        let isValidEmail = Helper.validateEmail(email)
        let isValidPassword = Helper.validatePassword(password)
        let passwordsMatch = Helper.passwordsMatch(password, confirmPassword: confirmPassword)
        if !isValidEmail {
            alert("E-mail", message: "Please enter a valid e-mail address.", buttonText: "OK")
            return false
        } else if !isValidPassword {
            alert("Password", message: "Password must be greater than 1 character", buttonText: "OK")
            return false
        } else if !passwordsMatch {
            alert("Confirm Password", message: "Passwords don't match", buttonText: "OK")
            return false
        }
        return true
    }
    
    func createUserRequest(email: String, username: String, password: String, confirmPassword: String) {
        let spinnerFrame: UIView = self.view.startASpinner()
        let parameters = ["username": username, "email": email, "password": password, "confirmationPassword": password]
        Alamofire.request(
            .POST,
            "http://routeme-api.us-east-1.elasticbeanstalk.com/api/users/",
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.view.stopSpinner(spinnerFrame)
                switch response.result {
                    case .Success(let JSON):
                        let HTTP_STATUS_CODE_CREATED: Int = 201
                        let statusCode = (response.response?.statusCode)!
                        let responseJSON = JSON as! NSDictionary
                        if (statusCode == HTTP_STATUS_CODE_CREATED) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.addBackground("seat_routeme.JPG")
        
        // text fields' tags are defined in the storyboard
        emailField.delegate = self // tag 0
        usernameField.delegate = self // tag 1
        passwordField.delegate = self // tag 2
        confirmPasswordField.delegate = self // tag 3

        // Do any additional setup after loading the view.
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
