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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        // Validate the text fields
        if username?.characters.count < 5 {
            UIAlertView(title: "Invalid", message: "Email must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK").show()
            
        } else if password?.characters.count < 1 {
            UIAlertView(title: "Invalid", message: "Password must be greater than 1 character", delegate: self, cancelButtonTitle: "OK").show()
            
        } else {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            // Run a spinner to show a task in progress
            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            
            
            let parameters = ["email": username!, "password": password!]
            
            Alamofire.request(.POST, "http://routeme-api.us-east-1.elasticbeanstalk.com/api/users/login", parameters: parameters, encoding:.JSON).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    spinner.stopAnimating()
                    let statusCode = (response.response?.statusCode)!
                    let response = JSON as! NSDictionary
                    if (statusCode == 302) {
                        let response = JSON as! NSDictionary
                        let loggedInUsername = response["username"] as! String
                        self.loginUser(loggedInUsername)
                        
                    } else {
                        let errorMessage = response["message"] as! String
                        let errorField = response["field"] as! String
                        UIAlertView(title: errorField, message: errorMessage, delegate: self, cancelButtonTitle: "OK").show()
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    }
    
    func loginUser(username: String) {
        self.rememberUser(username)
        self.redirectToMainView()
    }
    
    func redirectToMainView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    func rememberUser(username: String) {
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        if hasLoginKey == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
        }
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
