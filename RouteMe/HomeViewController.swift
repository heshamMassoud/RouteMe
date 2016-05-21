//
//  HomeViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 19/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logoutAction(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        redirectToLoginScreen()
        
    }

    override func viewWillAppear(animated: Bool) {
        let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        if (!isLoggedIn) {
            redirectToLoginScreen()
        }
    }

    func redirectToLoginScreen() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.addBackground("bus_routeme.jpeg")
        let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        if (isLoggedIn) {
            let loggedInId = NSUserDefaults.standardUserDefaults().valueForKey("loggedInId") as? String
            let loggedInUsername = NSUserDefaults.standardUserDefaults().valueForKey("loggedInUsername") as? String
            let loggedInEmail = NSUserDefaults.standardUserDefaults().valueForKey("loggedInEmail") as? String
            let loggedInUser = User(id: loggedInId!, username: loggedInUsername!, email: loggedInEmail!)
            usernameLabel.text = loggedInUser.username;
        }
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
