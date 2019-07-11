//
//  WishlistViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit
import RealmSwift

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var refreshControl = UIRefreshControl()
    
    let realm = try! Realm()
    
    var wishlistResult: Results<Wishlist>?
    
    @IBOutlet weak var WishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        WishlistTableView.delegate = self
//        WishlistTableView.dataSource = self
//
//        WishlistTableView.rowHeight = 70
//        WishlistTableView.separatorStyle = .none
        
        WishlistTableView.delegate = self
        WishlistTableView.dataSource = self
        
        WishlistTableView.rowHeight = 120.0
        
        WishlistTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
        
        //WishlistTableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "wishlistApp")
        
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
            //cell.appIcon.image = UIImage(named:"imagetest")
            cell.appPrice.text = wh.price
            cell.appName.text = wh.name
            
        }
        return cell
    }
    
}
