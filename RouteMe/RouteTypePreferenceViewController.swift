//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class RouteTypePreferenceViewController: UIViewController {
    @IBOutlet weak var leastTimeButton: UIButton!
    @IBOutlet weak var leastChangesButton: UIButton!
    @IBOutlet weak var leastTimeLabel: UILabel!
    @IBOutlet weak var leastChangesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBAction func leastTimeTapAction(sender: AnyObject) {
        leastTimeButton.addShadow()
        leastChangesButton.removeShadow()
    }

    @IBAction func leastChangesTapAction(sender: AnyObject) {
        leastChangesButton.addShadow()
        leastTimeButton.removeShadow()
    }

    override func viewDidLoad() {
        titleLabel.text = Placeholder.Title.RouteTypePreference
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
