//
//  AccountViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var accountTableView: UITableView!
    
    let menu = ["Account", "Edit Profile", "Help", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.rowHeight = 120.0
        accountTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        cell.appCategory.text = menu[indexPath.row]
        cell.appName.text = menu[indexPath.row]
        cell.appPrice.text = menu[indexPath.row]
        
        return cell
    }

}
