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
    
    var refreshControl = UIRefreshControl()
    
    let realm = try! Realm()
    
    var indexForSegue = 0
    
    var cartResult: Results<Cart>?
    
    @IBOutlet weak var cartTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.separatorStyle = .none
        cartTableView.rowHeight = 120.0
        
        cartTableView.rowHeight = 120.0
        
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadCategories), for: UIControl.Event.valueChanged)
        cartTableView.addSubview(refreshControl)
        
        loadCategories()
    }
    
    @objc private func loadCategories() {
        cartResult = realm.objects(Cart.self)
        self.cartTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartResult?.count ?? 1
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
