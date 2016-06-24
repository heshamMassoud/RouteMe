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
        Helper.logoutUser()
        Helper.redirectToViewController(self, targetViewControllerId: "Login", animated: true)
        
    }
    @IBAction func searchAction(sender: AnyObject) {
        Helper.redirectToViewController(self, targetViewControllerId: "PreferencesNav", animated: true)
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
    }

    override func viewWillAppear(animated: Bool) {
        processLoggedInUser()
    }
    
    func processLoggedInUser() {
        if (Helper.isUserLoggedIn()) {
            let loggedInUsername = Helper.getLoggedInUser().username
            usernameLabel.text = loggedInUsername;
        } else {
            Helper.redirectToViewController(self, targetViewControllerId: "Login", animated: false)

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "house-tab"), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground(Image.Background.Home)
        
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
