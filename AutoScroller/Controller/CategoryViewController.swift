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
    
    // MARK: - Initialize variables to hold JSON
    var productJSON : JSON?
    
    private var categoryJSON : JSON? {
        didSet {
            categoryTable.reloadData()
        }
    }
    
    // MARK: - Innitialize variables to count JSON
    var categoryCount : Int = 0
    
    // MARK: - Initialize variables to identify index
    var indeks : Int = 0
    
    // MARK: - Set up view
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
    
    // MARK: - Set tableview
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
            }
        }
        nextVC.productJSON = productJSON!
    }
}
