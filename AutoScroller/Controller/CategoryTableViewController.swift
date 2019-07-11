//
//  CategoryTableViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 24/06/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    let appCat = ["category1", "category2", "category3", "category4", "category5"]

    var index = 0
    
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appCat.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTable", for: indexPath)
        cell.textLabel?.text = appCat[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = appCat[indexPath.row]
        performSegue(withIdentifier: "categoryDetail", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SummaryDetailViewController
        destinationVC.category = category
        destinationVC.identifier = 4
        
    }
}
