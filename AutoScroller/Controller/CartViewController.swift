//
//  CartViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()

    @IBOutlet weak var cartTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.rowHeight = 120.0
        
        cartTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        cell.appCategory.text = "Test"
        cell.appName.text = "test"
        cell.appPrice.text = "test"
        
        return cell
    }
    

    @IBAction func checkoutButtonPressed(_ sender: Any) {
        print("checkout button pressed")
    }
    

}
