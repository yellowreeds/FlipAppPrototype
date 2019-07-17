//
//  WishlistViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var refreshControl = UIRefreshControl()
    
    var productJSON : JSON?
    
    let realm = try! Realm()
    
    var indexForSegue = 0
    
    var wishlistResult: Results<Wishlist>?
    
    @IBOutlet weak var WishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(productJSON!)
        WishlistTableView.delegate = self
        WishlistTableView.dataSource = self
        WishlistTableView.separatorStyle = .none
        WishlistTableView.rowHeight = 120.0
        
        WishlistTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadCategories), for: UIControl.Event.valueChanged)
        WishlistTableView.addSubview(refreshControl)
        
        loadCategories()
    }
    
    @objc private func loadCategories() {
        wishlistResult = realm.objects(Wishlist.self)
        self.WishlistTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistResult?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        if let wh = wishlistResult?[indexPath.row] {
            cell.appCategory.text = wh.category
            
            let url = URL(string: wh.icon)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                cell.appIcon.image = UIImage(data: imageData)
            }
            cell.appPrice.text = wh.price
            cell.appName.text = wh.name
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let wishlist = self.wishlistResult?[indexPath.row] {
                // create the alert
                let alert = UIAlertController(title: "Wishlist Delete", message: "Are you sure to delete this product from wishlist?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                    do {
                        try self.realm.write {
                            self.realm.delete(wishlist)
                        }
                    } catch {
                        print("Error write realm, \(error)")
                    }
                    completionHandler(true)
                    self.WishlistTableView.reloadData()
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
        indexForSegue = indexPath.row
        performSegue(withIdentifier: "wishlistDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        if let wh = wishlistResult?[indexForSegue] {
            destinationVC.appTitle = wh.name
            destinationVC.appCat = wh.category
            destinationVC.appPrice = Int(wh.price)!
            destinationVC.appDesc = wh.desc
        }
    }
}
