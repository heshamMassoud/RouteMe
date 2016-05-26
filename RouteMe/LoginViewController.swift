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
        let parameters = [API.LoginEndpoint.Parameter.Email: email, API.LoginEndpoint.Parameter.Password: password]
        Alamofire.request(
            .POST,
            API.LoginEndpoint.Path,
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.view.stopSpinner(spinnerFrame)
                switch response.result {
                    case .Success(let JSON):
                        let statusCode = (response.response?.statusCode)!
                        let responseJSON = JSON as! NSDictionary
                        if (statusCode == API.LoginEndpoint.Response.Found) {
                            self.processSuccessfulResponse(responseJSON)
                        } else {
                            Helper.alertRequestError(responseJSON, viewController: self)
                    }
                    case .Failure(let error):
                        self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }
    
    func processSuccessfulResponse(responseJSON: NSDictionary) {
        let loggedInId = responseJSON[API.LoginEndpoint.Key.Id] as! String
        let loggedInUsername = responseJSON[API.LoginEndpoint.Key.Username] as! String
        let loggedInEmail = responseJSON[API.LoginEndpoint.Key.Email] as! String
        let user = User(id: loggedInId, username: loggedInUsername, email: loggedInEmail)
        Helper.loginUser(user, viewController: self)
    }

    
    func validateLoginForm(email: String, password: String) -> Bool {
        let isValidEmail = Helper.validateEmail(email)
        let isValidPassword = Helper.validatePassword(password)
        if !isValidEmail {
            alert(Form.Field.Email, message: Form.Error.Email, buttonText: Form.AlertButton.Ok)
            return false
        } else if !isValidPassword {
            alert(Form.Field.Password, message: Form.Error.Password, buttonText: Form.AlertButton.Ok)
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
