//
//  SummaryDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 01/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class SummaryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Initialize variables for categories input
    var identifier = 0, index = 0, indexForSegue = 0, category = ""
    
    // MARK: - Initialize array for displaying in tableview
    var appTitle: [String] = [], price: [String] = [], image: [String] = [], appID: [String] = [], appScreenshoot1: [String] = [], appScreenshoot2: [String] = [], appScreenshoot3: [String] = [], appDesc: [String] = []
    
    // MARK: - Initialize variables for JSON
    var productJSON : JSON?
    
    // MARK: - Initialize IBOutlet
    @IBOutlet weak var appTableView: UITableView!
    
    // MARK: - Set the view
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the title in navigation bar
        navigationItem.title = category
        
        // set table delegate and data source
        appTableView.delegate = self
        appTableView.dataSource = self
        
        // set appearance for tableview
        appTableView.rowHeight = 120.0
        appTableView.separatorStyle = .none
        
        // register custom cell for table view
        appTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
        
    }
    
    // MARK: - Set tableview
    // set item on cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        if identifier == 2 {
            // identifier 2 is top application
            cell.appCategory.text = "\(productJSON!["data"][indexPath.row]["category_name"])"
            cell.appName.text = "\(productJSON!["data"][indexPath.row]["app_name"])"
            let url = URL(string: "\(productJSON!["data"][indexPath.row]["app_poster"])")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                cell.appIcon.image = UIImage(data: imageData)
            }
            cell.appPrice.text = "\(productJSON!["data"][indexPath.row]["app_price"])"
        } else if identifier == 3 {
            // identifier 3 is top rated
            cell.appCategory.text = "\(productJSON!["data"][indexPath.row]["category_name"])"
            cell.appName.text = "\(productJSON!["data"][indexPath.row]["app_name"])"
            let url = URL(string: "\(productJSON!["data"][indexPath.row]["app_poster"])")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                cell.appIcon.image = UIImage(data: imageData)
            }
            cell.appPrice.text = "\(productJSON!["data"][indexPath.row]["app_price"])"
        } else if identifier == 4 {
            // identifier 4 is category sorting
            if appTitle.count < 1 {
                // if no items in category
                cell.appCategory.text = ""
                cell.appName.text = "No item in this category"
                cell.appPrice.text = ""
            } else {
                cell.appCategory.text = category
                cell.appName.text = appTitle[indexPath.row]
                let url = URL(string: image[indexPath.row])
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    cell.appIcon.image = UIImage(data: imageData)
                }
                cell.appPrice.text = price[indexPath.row]
            }
        }
        return cell
    }
    
    // when items is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSegue = indexPath.row
        if identifier == 4 {
            if appTitle.count < 1 {
                self.view.makeToast("No Items", duration: 3.0, position: .bottom)
            } else {
                performSegue(withIdentifier: "detailApp", sender: self)
            }
        } else {
            if productJSON!["data"].count < 1 {
                self.view.makeToast("No Items", duration: 3.0, position: .bottom)
            } else {
                performSegue(withIdentifier: "detailApp", sender: self)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if identifier == 4 {
            if appTitle.count < 1 {
                return 1
            } else {
                return appTitle.count
            }
        } else {
            return productJSON!["data"].count
        }
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        if identifier == 4 {
            destinationVC.appID = appID[indexForSegue]
            destinationVC.imgArr.append(appScreenshoot1[indexForSegue])
            destinationVC.imgArr.append(appScreenshoot2[indexForSegue])
            destinationVC.imgArr.append(appScreenshoot3[indexForSegue])
            destinationVC.appTitle = appTitle[indexForSegue]
            destinationVC.appCat = category
            destinationVC.appPrice = Int(price[indexForSegue])!
            destinationVC.appDesc = appDesc[indexForSegue]
        } else {
            destinationVC.appID = "\(productJSON!["data"][indexForSegue]["app_id"])"
            destinationVC.imgArr.append("\(productJSON!["data"][indexForSegue]["app_screen_capture_1"])")
            destinationVC.imgArr.append("\(productJSON!["data"][indexForSegue]["app_screen_capture_2"])")
            destinationVC.imgArr.append("\(productJSON!["data"][indexForSegue]["app_screen_capture_3"])")
            destinationVC.appTitle = "\(productJSON!["data"][indexForSegue]["app_name"])"
            destinationVC.appCat = "\(productJSON!["data"][indexForSegue]["category_name"])"
            destinationVC.appPrice = Int("\(productJSON!["data"][indexForSegue]["app_price"])")!
            destinationVC.appDesc = "\(productJSON!["data"][indexForSegue]["app_desc"])"
        }
        
    }

}
