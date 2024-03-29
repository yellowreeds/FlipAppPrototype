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
    
    // MARK: - IBOUTLET
    @IBOutlet weak var categoryTable: UITableView!
    
    // MARK: - HOLD JSON
    var productJSON : JSON?
    private var categoryJSON : JSON? {
        didSet {
            categoryTable.reloadData()
        }
    }
    var categoryCount : Int = 0
    
    // MARK: - IDENTIFY INDEX
    var indeks : Int = 0
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get JSON
        getData()
        
        // set delegate and data source
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        // set tableview appearance
        categoryTable.rowHeight = 70.0
        categoryTable.separatorStyle = .none
    }
    
    // MARK: - GET API
    func getData() {
        Alamofire.request("https://amentiferous-grass.000webhostapp.com/api/category?fliptoken=flip123", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.categoryJSON = JSON(response.result.value!)
            } else {
                print("Error: \(response.result.error)")
            }
        }
    }
    
    // MARK: - TABLE VIEW
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryJSON?["data"].count ?? 0
    }
    
    // set item on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTable", for: indexPath)
        cell.textLabel?.text = "\(categoryJSON!["data"][indexPath.row]["category_name"])"
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
        for n in 0...productJSON!.count-1 {
            if "\(productJSON![n]["category_name"])" == "\(categoryJSON!["data"][indeks]["category_name"])" {
                nextVC.appTitle.append("\(productJSON![n]["app_name"])")
                nextVC.category = ("\(productJSON![n]["category_name"])")
                nextVC.image.append("\(productJSON![n]["app_poster"])")
                nextVC.price.append("\(productJSON![n]["app_price"])")
                nextVC.appID.append("\(productJSON![n]["app_id"])")
                nextVC.appScreenshoot1.append("\(productJSON![n]["app_screen_capture_1"])")
                nextVC.appScreenshoot2.append("\(productJSON![n]["app_screen_capture_2"])")
                nextVC.appScreenshoot3.append("\(productJSON![n]["app_screen_capture_3"])")
                nextVC.appDesc.append("\(productJSON![n]["app_desc"])")
            }
        }
        nextVC.productJSON = productJSON!
    }
}
