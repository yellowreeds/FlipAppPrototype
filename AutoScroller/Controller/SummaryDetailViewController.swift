//
//  SummaryDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 01/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class SummaryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let imgArr = [  UIImage(named:"imagetest"),
                    UIImage(named:"imagetest"),
                    UIImage(named:"imagetest")
    ]
    
    var identifier = 0, index = 0, indexForSegue = 0, category = ""
    
    var appTitle: [String] = [], price: [String] = [], appCategory: [String] = [], image: [String] = []
    
    var productJSON : JSON?
    
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
            if "\(productJSON!["data"][indexPath.row]["category_id"])" == "2" {
                cell.appCategory.text = "Contacts Top"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "3" {
                cell.appCategory.text = "Locations Top"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "5" {
                cell.appCategory.text = "Storage Top"
            }  else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "11" {
                cell.appCategory.text = "Android/IOS Top"
            }  else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "13" {
                cell.appCategory.text = "Smart Home Top"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "0" || "\(productJSON!["data"][indexPath.row]["category_id"])" == "1" {
                cell.appCategory.text = "Tidak terkategori"
            }
            cell.appName.text = "\(productJSON!["data"][indexPath.row]["app_name"])"
            cell.appIcon.image = UIImage(named:"imagetest")
            cell.appPrice.text = "\(productJSON!["data"][indexPath.row]["app_harga"])"
        } else if identifier == 3 {
            if "\(productJSON!["data"][indexPath.row]["category_id"])" == "2" {
                cell.appCategory.text = "Contacts Rate"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "3" {
                cell.appCategory.text = "Locations Rate"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "5" {
                cell.appCategory.text = "Storage Rate"
            }  else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "11" {
                cell.appCategory.text = "Android/IOS Rate"
            }  else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "13" {
                cell.appCategory.text = "Smart Home Rate"
            } else if "\(productJSON!["data"][indexPath.row]["category_id"])" == "0" {
                cell.appCategory.text = "Kategori belum ditentukan"
            }
            cell.appName.text = "\(productJSON!["data"][indexPath.row]["app_name"])"
            cell.appIcon.image = UIImage(named:"imagetest")
            cell.appPrice.text = "\(productJSON!["data"][indexPath.row]["app_harga"])"
        } else if identifier == 4 {
            if appTitle.count < 1 {
                cell.appCategory.text = ""
                cell.appName.text = "No item in this category"
                //cell.appIcon.image = UIImage(named:)
                cell.appPrice.text = ""
            } else {
                cell.appCategory.text = category
                cell.appName.text = appTitle[indexPath.row]
                //cell.appIcon.image = UIImage(named:)
                cell.appPrice.text = price[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSegue = indexPath.row
        if appTitle.count < 1 {
            self.view.makeToast("No Items", duration: 3.0, position: .bottom)
        } else {
            performSegue(withIdentifier: "detailApp", sender: self)
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        
        destinationVC.appTitle = "\(productJSON!["data"][indexForSegue]["app_name"])"
        destinationVC.appCat = category
        destinationVC.appPrice = Int("\(productJSON!["data"][indexForSegue]["app_harga"])")!
        destinationVC.appDesc = "\(productJSON!["data"][indexForSegue]["app_desc"])"
    }

}
