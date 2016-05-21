//
//  SignUpViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        var email = self.emailField.text
        var finalEmail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        // Validate the text fields
        if username?.characters.count < 5 {
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password?.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email?.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
            // Run a spinner to show a task in progress
            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            let parameters = ["username": username!, "email": email!, "password": password!, "confirmationPassword": password!]
            
            Alamofire.request(.POST, "http://routeme-api.us-east-1.elasticbeanstalk.com/api/users/", parameters: parameters, encoding:.JSON).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    spinner.stopAnimating()
                    let statusCode = (response.response?.statusCode)!
                    let response = JSON as! NSDictionary
                    if (statusCode == 201) {
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground("tram_routeme.jpeg")
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
