//
//  CategoryViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 16/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var categoryTable: UITableView!
    
    let category = ["Contacts", "Location", "Storage", "Android / iOS", "Smarthome"]
    
    var productJSON : JSON?
    
    var indeks : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.rowHeight = 70.0
        categoryTable.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTable", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row]
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indeks = indexPath.row
        performSegue(withIdentifier: "categoryDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SummaryDetailViewController
        nextVC.identifier = 4
        if indeks == 0 {
            for n in 0...productJSON!.count-1 {
                if "\(productJSON![n]["category_id"])" == "2" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Contacts"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 1 {
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "3" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Locations"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
                
            }
        } else if indeks == 2 {
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "5" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Storage"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 3 {
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "11" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Android / iOS"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 4 {
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "13" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Smart Home"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        }
    }
}
