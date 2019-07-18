//
//  CategoryViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 16/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet for category table
    @IBOutlet weak var categoryTable: UITableView!
    
    // MARK: - Initialize Categories
    let category = ["Contacts", "Location", "Storage", "Android / iOS", "Smarthome"]
    
    // MARK: - Initialize variables to hold JSON
    var productJSON : JSON?
    
    // MARK: - Initialize variables to identify index
    var indeks : Int = 0
    
    // MARK: - Set up view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate and data source
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        // set tableview appearance
        categoryTable.rowHeight = 70.0
        categoryTable.separatorStyle = .none
        
    }
    
    // MARK: - Set tableview
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    // set item on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTable", for: indexPath)
        cell.textLabel?.text = category[indexPath.row]
        return cell
    }
    
    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indeks = indexPath.row
        performSegue(withIdentifier: "categoryDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SummaryDetailViewController
        nextVC.identifier = 4
        if indeks == 0 {
            // if contact is presssed
            for n in 0...productJSON!.count-1 {
                if "\(productJSON![n]["category_id"])" == "2" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Contacts"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 1 {
           // if locations is presssed
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "3" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Locations"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
                
            }
        } else if indeks == 2 {
            // if storage is presssed
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "5" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Storage"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 3 {
            // if Android / iOS is presssed
            for n in 0...productJSON!.count-1 {
                if productJSON![n]["category_id"] == "11" {
                    nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                    nextVC.category = "Android / iOS"
                    nextVC.image.append("\(productJSON![n]["app_foto"])")
                    nextVC.price.append("\(productJSON![n]["app_harga"])")
                }
            }
        } else if indeks == 4 {
            // if smart home is presssed
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
