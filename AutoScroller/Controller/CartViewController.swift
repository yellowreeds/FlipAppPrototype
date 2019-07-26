//
//  CartViewController.swift
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

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - REFRESH CONTROL
    var refreshControl = UIRefreshControl()
    
    // MARK: - HOLD JSON
    var productJSON : JSON?
    var productCount : Int = 0
    
    var cartJSON : JSON? {
        didSet {
            cartTableView.reloadData()
        }
    }
    
    // MARK: - INIT CART ID
    var cartID = ""
    
    // MARK: - INIT REALM
    let realm = try! Realm()
    
    // MARK: - VARIABLES FOR INDENTIFICATION
    var indexForSegue = 0
    
    // MARK: - HOLD REALM
    var cartResult: Results<Cart>?
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
    @IBOutlet weak var cartTableView: UITableView!

    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        productCount = productJSON!.count
        
        // set delegate and tablesource
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        // set tableview appearance
        cartTableView.separatorStyle = .none
        cartTableView.rowHeight = 358.0
        
        // register custom cell
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        // set refreshcontrol function
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadCartFromAPI), for: UIControl.Event.valueChanged)
        cartTableView.addSubview(refreshControl)
        
        cartResult = realm.objects(Cart.self)
        loadCartFromAPI()
    }
    
    // MARK: - LOAD API
    func getData() {
        Alamofire.request("https://amentiferous-grass.000webhostapp.com/api/cart?fliptoken=flip123&user_id=\(userid)", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.cartJSON = JSON(response.result.value!)
            } else {
                print("Error: \(response.result.error)")
            }
        }
    }
    
    
    // MARK: - LOAD FROM REALM
    @objc private func loadCart() {
        cartResult = realm.objects(Cart.self)
        self.cartTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - RELOAD FROM API
    @objc private func loadCartFromAPI() {
        getData()
        self.cartTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - TABLE VIEW
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartJSON?["data"].count ?? 0
    }
    
    // set item on row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cartID = "\(cartJSON!["data"][indexPath.row]["cart_id"])"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        cell.appCategory.text = "\(cartJSON!["data"][indexPath.row]["category_name"])"
        let url = URL(string: "\(cartJSON!["data"][indexPath.row]["app_poster"])")
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            cell.appImage.image = UIImage(data: imageData)
        }
        cell.appPrice.text = "\(cartJSON!["data"][indexPath.row]["app_price"])"
        cell.appName.text = "\(cartJSON!["data"][indexPath.row]["app_name"])"
        
        return cell
    }
    
    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSegue = indexPath.row
        performSegue(withIdentifier: "cartDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // set swipe to delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // create the alert
            let alert = UIAlertController(title: "Cart Delete", message: "Are you sure to delete this product from cart?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                self.view.makeToastActivity(.center)
                
                let url = "https://amentiferous-grass.000webhostapp.com/api/cart/delete"
                let parameters: Parameters = ["fliptoken" : "flip123", "cart_id" : self.cartID]
                
                Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
                    if response.result.isSuccess {
                        if self.cartResult!.count > 0 {
                            if let cart = self.cartResult?[indexPath.row] {
                                do {
                                    try self.realm.write {
                                        self.realm.delete(cart)
                                    }
                                } catch {
                                    print("Error write realm, \(error)")
                                }
                            }
                        }
                        self.loadCartFromAPI()
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
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AppDetailViewController
        destinationVC.appID = "\(cartJSON!["data"][indexForSegue]["app_id"])"
        if cartResult!.count > 0 {
            if let cart = cartResult?[indexForSegue] {
                destinationVC.appTitle = cart.name
                destinationVC.appCat = cart.category
                destinationVC.appPrice = Int(cart.price)!
                destinationVC.appDesc = cart.desc
                destinationVC.imgArr.append(cart.poster1)
                destinationVC.imgArr.append(cart.poster2)
                destinationVC.imgArr.append(cart.poster3)
            }
        } else {
            for n in 0...productCount-1 {
                if "\(productJSON![n]["app_id"])" == "\(cartJSON!["data"][indexForSegue]["app_id"])" {
                    destinationVC.appDesc = "\(productJSON![n]["app_desc"])"
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_1"])")
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_2"])")
                    destinationVC.imgArr.append("\(productJSON![n]["app_screen_capture_3"])")
                }
                destinationVC.appTitle = "\(cartJSON!["data"][indexForSegue]["app_name"])"
                destinationVC.appCat = "\(cartJSON!["data"][indexForSegue]["category_name"])"
                destinationVC.appPrice = Int("\(cartJSON!["data"][indexForSegue]["app_price"])")!
                
                
            }
            
        }
        
    }
    
}
