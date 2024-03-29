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
import Alamofire
import Toast_Swift

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - REFRESH CONTROL
    var refreshControl = UIRefreshControl()
    
    // MARK: - HOLD JSON
    var productJSON : JSON?
    var productCount : Int = 0
    
    var wishlistJSON : JSON? {
        didSet {
            WishlistTableView.reloadData()
        }
    }
    
    // MARK: - INIT REALM
    let realm = try! Realm()
    
    // MARK: - INDEX FOR SEGUE
    var indexForSegue = 0
    
    // MARK: - WISHLIST ID
    var wishlistID = ""
    
    // MARK: - HOLD REALM
    var wishlistResult: Results<Wishlist>?
    var accountResult: Results<Account>?
    
    // MARK: - SET USER ID
    var userid: String = ""
    override func viewWillAppear(_ animated: Bool) {
        accountResult = realm.objects(Account.self)
        if accountResult!.count > 0 {
            if let account = accountResult?[0] {
                userid = account.userID
            }
        }
    }
    
    // MARK: - IBOUTLET
    @IBOutlet weak var WishlistTableView: UITableView!
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        productCount = productJSON!.count
        // MARK: Set and register the tableview
        // set delegate and data source
        WishlistTableView.delegate = self
        WishlistTableView.dataSource = self
        
        // set separator style and row height
        WishlistTableView.separatorStyle = .none
        WishlistTableView.rowHeight = 120.0
        
        // register custom cell
        WishlistTableView.register(UINib(nibName: "CustomSummaryAppTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryApp")
        
        // set refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadWishlistFromAPI), for: UIControl.Event.valueChanged)
        WishlistTableView.addSubview(refreshControl)
        
        // call the function to load wishlist from realm to tableview
        //loadWishlist()
        wishlistResult = realm.objects(Wishlist.self)
        loadWishlistFromAPI()
    }
    
    // MARK: - LOAD WISHLIST API
    func getData() {
        Alamofire.request("https://amentiferous-grass.000webhostapp.com/api/wishlist?fliptoken=flip123&user_id=\(userid)", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.wishlistJSON = JSON(response.result.value!)
            } else {
                print("Error: \(response.result.error)")
            }
        }
    }
    
    // MARK: - LOAD WISHLIST REALM
    @objc private func loadWishlist() {
        wishlistResult = realm.objects(Wishlist.self)
        self.WishlistTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - RELOAD WISHLIST API
    @objc private func loadWishlistFromAPI() {
        getData()
        self.WishlistTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - TABLE VIEW
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistJSON?["data"].count ?? 0
    }
    
    // set item on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        wishlistID = "\(wishlistJSON!["data"][indexPath.row]["wishlist_id"])"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryApp", for: indexPath) as! CustomSummaryAppTableViewCell
        
        cell.appCategory.text = "\(wishlistJSON!["data"][indexPath.row]["category_name"])"
        let url = URL(string: "\(wishlistJSON!["data"][indexPath.row]["app_poster"])")
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            cell.appIcon.image = UIImage(data: imageData)
        }
        
        cell.appPrice.text = "\(wishlistJSON!["data"][indexPath.row]["app_price"])"
        cell.appName.text = "\(wishlistJSON!["data"][indexPath.row]["app_name"])"
        return cell
    }
    
    // set the swipe to delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                // create the alert
            let alert = UIAlertController(title: "Wishlist Delete", message: "Are you sure to delete this product from wishlist?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                self.view.makeToastActivity(.center)
                
                let url = "https://amentiferous-grass.000webhostapp.com/api/wishlist/delete"
                let parameters: Parameters = ["fliptoken" : "flip123", "wishlist_id" : self.wishlistID]
                
                Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
                    if response.result.isSuccess {
                        if self.wishlistResult!.count > 0 {
                            if let wishlist = self.wishlistResult?[indexPath.row] {
                                do {
                                    try self.realm.write {
                                        self.realm.delete(wishlist)
                                    }
                                } catch {
                                    print("Error write realm, \(error)")
                                }
                            }
                        }
                        self.loadWishlistFromAPI()
                        self.view.hideToastActivity()
                    } else {
                        print("Error \(response.result.error)")
                    }
                }
                completionHandler(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
                completionHandler(false)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        delete.image = UIImage(named: "erase")
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    // set when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSegue = indexPath.row
        performSegue(withIdentifier: "wishlistDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare the segue when cell is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        destinationVC.appID = "\(wishlistJSON!["data"][indexForSegue]["app_id"])"
        if wishlistResult!.count > 0 {
            if let wh = wishlistResult?[indexForSegue] {
                destinationVC.appTitle = wh.name
                destinationVC.appCat = wh.category
                destinationVC.appPrice = Int(wh.price)!
                destinationVC.appDesc = wh.desc
                destinationVC.imgArr.append(wh.poster1)
                destinationVC.imgArr.append(wh.poster2)
                destinationVC.imgArr.append(wh.poster3)
            }
        } else {
            for n in 0...productCount-1 {
                if "\(productJSON![n]["app_id"])" == "\(wishlistJSON!["data"][indexForSegue]["app_id"])" {
                    destinationVC.appDesc = "\(productJSON![n]["app_desc"])"
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_1"])")
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_2"])")
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_3"])")
                }
                destinationVC.appTitle = "\(wishlistJSON!["data"][indexForSegue]["app_name"])"
                destinationVC.appCat = "\(wishlistJSON!["data"][indexForSegue]["category_name"])"
                destinationVC.appPrice = Int("\(wishlistJSON!["data"][indexForSegue]["app_price"])")!
            }
        }
    }
}
