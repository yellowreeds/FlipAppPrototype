//
//  CategoryDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 24/06/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    var a = ""
    var b = ""

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = a
        
        // Do any additional setup after loading the view.
    }
}
