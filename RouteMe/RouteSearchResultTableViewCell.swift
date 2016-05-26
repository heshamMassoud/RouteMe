//
//  RouteSearchResultTableViewCell.swift
//  RouteMe
//
//  Created by Hesham Massoud on 24/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit

class RouteSearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var routeSummaryLabel: UILabel!
    
    override func prepareForReuse() {
        for view in self.subviews {
            if let label = view as? UILabel {
                label.removeFromSuperview()
            }
            if let image = view as? UIImageView {
                image.removeFromSuperview()
            }
        }
        
    }
}

