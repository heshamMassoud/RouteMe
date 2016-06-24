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
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var closeButton: UIButton!


    @IBAction func signUpAction(sender: AnyObject) {
        let email = self.emailField.text
        let username = self.usernameField.text
        let password = self.passwordField.text
        let confirmPassword = self.confirmPasswordField.text
        
        let isFormValid = validateSignUpForm(email!, username: username!, password: password!, confirmPassword: confirmPassword!)
        if isFormValid {
            let alert = UIAlertController(title: "Notice", message: "We keep track of all your interactions with the app. This includes route views, search queries, etc.. In order to provide personalised route recommendations for you as accurate as possible.", preferredStyle: UIAlertControllerStyle.Alert);
            let okButton = UIAlertAction(title: "Accept", style: .Default, handler: { (action: UIAlertAction!) in
                self.createUserRequest(email!, username: username!, password: password!)
            })
            let cancelButton = UIAlertAction(title: "Decline", style: .Cancel, handler: { (action: UIAlertAction!) in })
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            showViewController(alert, sender: self);
        }
    }

    
    func validateSignUpForm(email: String, username: String, password: String, confirmPassword: String) -> Bool {
        let isValidEmail = Helper.validateEmail(email)
        let isValidPassword = Helper.validatePassword(password)
        let passwordsMatch = Helper.passwordsMatch(password, confirmPassword: confirmPassword)
        if !isValidEmail {
            alert(Form.Field.Email, message: Form.Error.Email, buttonText: Form.AlertButton.Ok)
            return false
        } else if !isValidPassword {
            alert(Form.Field.Password, message: Form.Error.Password, buttonText: Form.AlertButton.Ok)
            return false
        } else if !passwordsMatch {
            alert(Form.Field.ConfirmationPassword, message: Form.Error.ConfirmationPassword, buttonText: Form.AlertButton.Ok)
            return false
        }
        return true
    }
    
    func createUserRequest(email: String, username: String, password: String) {
        let spinnerFrame: UIView = self.view.startASpinner()
        let parameters = [API.UserEndpoint.Parameter.Username: username,
                          API.UserEndpoint.Parameter.Email: email,
                          API.UserEndpoint.Parameter.Password: password]
        Alamofire.request(
            .POST,
            API.UserEndpoint.Path,
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
                        if (statusCode == API.UserEndpoint.Response.Created) {
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
        let loggedInId = responseJSON[API.UserEndpoint.Key.Id] as! String
        let loggedInUsername = responseJSON[API.UserEndpoint.Key.Username] as! String
        let loggedInEmail = responseJSON[API.UserEndpoint.Key.Email] as! String
        let user = User(id: loggedInId, username: loggedInUsername, email: loggedInEmail, travelModePreference: [], routeTypePreference: [])
        Helper.loginUserAndAskForPreferences(user, viewController: self)
    }

    override func keyboardWillShow(notification: NSNotification) {
        self.keyboardHeight = Helper.getKeyboardHeight(notification)
        self.view.window?.frame.origin.y = -0.45 * keyboardHeight
    }

    override func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y += 0.45 * keyboardHeight
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.addBackground(Image.Background.Signup)
        registerForKeyboardNotifications()
        
        setTextFieldsDelegates()
        setTextFieldsBottomBorders()
        closeButton.backgroundColor = UIColor(white: 1, alpha: 0)
        
        // Do any additional setup after loading the view.
    }

    func setTextFieldsDelegates() {
        // text fields' tags are defined in the storyboard
        emailField.delegate = self // tag 0
        usernameField.delegate = self // tag 1
        passwordField.delegate = self // tag 2
        confirmPasswordField.delegate = self // tag 3
    }
    
    func setTextFieldsBottomBorders() {
        Helper.setTextFieldBottomBorder(emailField)
        Helper.setTextFieldBottomBorder(usernameField)
        Helper.setTextFieldBottomBorder(passwordField)
        Helper.setTextFieldBottomBorder(confirmPasswordField)
    }

    override func viewDidDisappear(animated: Bool) {
        deregisterFromKeyboardNotifications()
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
