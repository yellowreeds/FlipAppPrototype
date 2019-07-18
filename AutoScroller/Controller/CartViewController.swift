//
//  CartViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Initialize refresh control
    var refreshControl = UIRefreshControl()
    
    // MARK: - Initialize Realm
    let realm = try! Realm()
    
    // MARK: - Initialize variables for identification
    var indexForSegue = 0
    
    // MARK: - Initialize result to load Realm
    var cartResult: Results<Cart>?
    
    // MARK: - IBOutlet for cart table view
    @IBOutlet weak var cartTableView: UITableView!

    // MARK: - Set up the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate and tablesource
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        // set tableview appearance
        cartTableView.separatorStyle = .none
        cartTableView.rowHeight = 120.0
        
        // register custom cell
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        // set refreshcontrol function
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadCart), for: UIControl.Event.valueChanged)
        cartTableView.addSubview(refreshControl)
        
        // load categories from Realm
        loadCart()
    }
    
    // MARK: - Function to load cart from Realm
    @objc private func loadCart() {
        cartResult = realm.objects(Cart.self)
        self.cartTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - set table view
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartResult?.count ?? 1
    }
    
    // set item on row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        if let c = cartResult?[indexPath.row] {
            cell.appCategory.text = c.category
            cell.appImage.image = UIImage(named:"imagetest")
            cell.appPrice.text = c.price
            cell.appName.text = c.name
            
        }
        return cell
    }
    
    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe to delete function
    // set swipe to delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let cart = self.cartResult?[indexPath.row] {
                // create the alert
                let alert = UIAlertController(title: "Wishlist Delete", message: "Are you sure to delete this product from wishlist?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                    do {
                        try self.realm.write {
                            self.realm.delete(cart)
                        }
                    } catch {
                        print("Error write realm, \(error)")
                    }
                    completionHandler(true)
                    self.cartTableView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
                    completionHandler(false)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        delete.image = UIImage(named: "erase")
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }    
}
