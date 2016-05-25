//
//  Helpers.swift
//  RouteMe
//
//  Created by Hesham Massoud on 21/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation
import UIKit

class Helper{
    static func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailEvaluator = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailEvaluator.evaluateWithObject(email)
    }

    static func validatePassword(password: String) -> Bool {
        return password.characters.count > 1
    }

    static func passwordsMatch(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }

    static func alertRequestError(responseJSON: NSDictionary, viewController: UIViewController) {
        let FIRST_FIELD_ERROR_INDEX = 0
        let FIRST_FIELD_ERROR_ENTRY = responseJSON["fieldErrors"]![FIRST_FIELD_ERROR_INDEX] as AnyObject
        let errorMessage = FIRST_FIELD_ERROR_ENTRY["message"] as! String
        let errorField = FIRST_FIELD_ERROR_ENTRY["field"] as! String
        viewController.alert(errorField, message: errorMessage, buttonText: "OK")
    }

    static func loginUser(user: User, viewController: UIViewController) {
        rememberUser(user)
        redirectToViewController(viewController, targetViewControllerId: "PreferencesNav", animated: true)
    }

    static func rememberUser(user: User) {
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        if hasLoginKey == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().setValue(user.id, forKey: "loggedInId")
            NSUserDefaults.standardUserDefaults().setValue(user.username, forKey: "loggedInUsername")
            NSUserDefaults.standardUserDefaults().setValue(user.email, forKey: "loggedInEmail")
        }
    }

    static func redirectToViewController(viewController: UIViewController, targetViewControllerId: String, animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let targetViewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(targetViewControllerId)
            viewController.presentViewController(targetViewController, animated: animated, completion: nil)
        })
    }

    static func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        return (keyboardSize?.height)!
    }

    static func setTextFieldBottomBorder(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, textField.frame.height - 0.5, textField.frame.width, 0.5)
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        textField.borderStyle = UITextBorderStyle.None
        textField.layer.addSublayer(bottomLine)
    }
    
}