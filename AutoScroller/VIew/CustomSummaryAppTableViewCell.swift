//
//  CustomSummaryAppTableViewCell.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 28/06/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class CustomSummaryAppTableViewCell: UITableViewCell {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appCategory: UILabel!
    @IBOutlet weak var appPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
