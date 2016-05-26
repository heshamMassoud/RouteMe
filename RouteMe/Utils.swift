//
//  Utils.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

extension UIView {
    func addBackground(bgImagePath: String) {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: bgImagePath)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    func startASpinner() -> UIView {
        var messageFrame = UIView()
        var activityIndicator = UIActivityIndicatorView()
        messageFrame = UIView(frame: CGRect(x: self.frame.midX - 25, y: self.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        self.addSubview(messageFrame)
        return messageFrame
    }
    
    func stopSpinner(spinnerFrame: UIView) {
        spinnerFrame.removeFromSuperview()
    }
    
}

extension UIButton {
    func addShadow(){
        self.layer.shadowColor = UIColor(hexString: Style.ColorPallete.Blue)?.CGColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 30
        self.layer.cornerRadius = 12.0
    }
    
    func removeShadow(){
        self.layer.shadowOpacity = 0
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        let alertButton = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: {(actionTarget: UIAlertAction) in })
        alert.addAction(alertButton)
        showViewController(alert, sender: self);
    }
    
    func redirectToMainView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextFieldTag = textField.tag + 1
        if let nextViewResponder: UIResponder! = self.view.viewWithTag(nextFieldTag) {
            nextViewResponder.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return false
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
    }
    
    func keyboardWillHide(notification: NSNotification) {
    }
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

