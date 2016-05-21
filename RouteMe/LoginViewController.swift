//
//  LoginViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
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
        let spinnerFrame: UIView = startASpinner()
        let parameters = ["email": email, "password": password]
        Alamofire.request(
            .POST,
            "http://routeme-api.us-east-1.elasticbeanstalk.com/api/users/login",
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.stopSpinner(spinnerFrame)
                switch response.result {
                    case .Success(let JSON):
                        let HTTP_STATUS_CODE_FOUND: Int = 302
                        let statusCode = (response.response?.statusCode)!
                        let responseJSON = JSON as! NSDictionary
                        if (statusCode == HTTP_STATUS_CODE_FOUND) {
                            let loggedInUsername = responseJSON["username"] as! String
                            self.loginUser(loggedInUsername)
                        } else {
                            self.alertAuthenticationError(responseJSON)
                    }
                    case .Failure(let error):
                        self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }
    
    func startASpinner() -> UIView {
        var messageFrame = UIView()
        var activityIndicator = UIActivityIndicatorView()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        view.addSubview(messageFrame)
        return messageFrame
    }
    
    func stopSpinner(spinnerFrame: UIView) {
        spinnerFrame.removeFromSuperview()
    }
    
    func validateLoginForm(email: String, password: String) -> Bool {
        let isValidEmail = validateEmailField(email)
        let isValidPassword = validatePasswordField(password)
        if !isValidEmail {
            alert("E-mail", message: "Please enter a valid e-mail address.", buttonText: "OK")
            return false
        } else if !isValidPassword {
            alert("Password", message: "Password must be greater than 1 character", buttonText: "OK")
            return false
        }
        return true
    }
    
    func validateEmailField(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailEvaluator = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailEvaluator.evaluateWithObject(email)
    }
    
    func validatePasswordField(password: String) -> Bool {
        return password.characters.count > 1
    }

    func alert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        let alertButton = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: {(actionTarget: UIAlertAction) in })
        alert.addAction(alertButton)
        showViewController(alert, sender: self);
    }
    

    func loginUser(username: String) {
        self.rememberUser(username)
        self.redirectToMainView()
    }
    
    func rememberUser(username: String) {
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        if hasLoginKey == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
        }
    }
    
    func redirectToMainView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    func alertAuthenticationError(responseJSON: NSDictionary) {
        let AUTHENTICATION_FIELD_ERROR_INDEX = 0
        let AUTHENTICATION_FIELD_ERROR_ENTRY = responseJSON["fieldErrors"]![AUTHENTICATION_FIELD_ERROR_INDEX] as AnyObject
        let errorMessage = AUTHENTICATION_FIELD_ERROR_ENTRY["message"] as! String
        let errorField = AUTHENTICATION_FIELD_ERROR_ENTRY["field"] as! String
        self.alert(errorField, message: errorMessage, buttonText: "OK")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.addBackground("city_routeme.jpg")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
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
