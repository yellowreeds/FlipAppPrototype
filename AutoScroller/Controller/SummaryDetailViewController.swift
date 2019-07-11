//
//  SummaryDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 01/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class SummaryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let imgArr = [  UIImage(named:"imagetest"),
                    UIImage(named:"imagetest"),
                    UIImage(named:"imagetest")
    ]
    
    let appName = ["Name1", "Name2", "Name3", "Name4", "Name5", "Name6", "Name7", "Name8", "Name9", "Name10", "Name11"
    ]
    
    let appDescription = ["Desc1", "Desc2", "Desc3", "Desc4", "Desc5", "Desc6", "Desc7", "Desc8", "Desc9", "Desc10", "Desc11"]
    
    let appPrice = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000
    ]
    
    let appCat = ["category1", "category1", "category2", "category3", "category2", "category5", "category2", "category1", "category4", "category4", "category3"]

    var identifier = 0, category = "", index = 0, indexForSegue = 0
    
    @IBOutlet weak var appTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category
        appTableView.delegate = self
        appTableView.dataSource = self
        
        appTableView.rowHeight = 120.0
        
        appTableView.separatorStyle = .none
        
        appTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        if identifier == 2 {
            cell.appCategory.text = "\(appCat[indexPath.row]) top"
            cell.appName.text = appName[indexPath.row]
            cell.appIcon.image = UIImage(named:"imagetest")
            cell.appPrice.text = String(appPrice[indexPath.row])
        } else if identifier == 3 {
            cell.appCategory.text = "\(appCat[indexPath.row]) rate"
            cell.appName.text = appName[indexPath.row]
            cell.appIcon.image = UIImage(named:"imagetest")
            cell.appPrice.text = String(appPrice[indexPath.row])
        } else if identifier == 4 {
            if appCat[indexPath.row] == category {
                index = indexPath.row
                cell.appCategory.text = category
                cell.appName.text = appName[index]
                cell.appIcon.image = UIImage(named:"imagetest")
                cell.appPrice.text = String(appPrice[index])
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSegue = indexPath.row
        performSegue(withIdentifier: "detailApp", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        
        destinationVC.appTitle = appName[indexForSegue]
        destinationVC.appCat = appCat[indexForSegue]
        destinationVC.appPrice = appPrice[indexForSegue]
        destinationVC.appDesc = appDescription[indexForSegue]
    }

}
