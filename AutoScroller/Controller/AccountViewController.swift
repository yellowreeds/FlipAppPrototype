//
//  AccountViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 02/07/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet for tableview
    @IBOutlet weak var accountTableView: UITableView!
    
    // MARK: - Initialize Realm
    let realm = try! Realm()
    
    // MARK: - Initialize menu for account settings
    let menu = ["Account", "Edit Profile", "Help", "Logout", "Testing baru"]
    
    // MARK: - Initialize variable for indentification
    var identifier = 0
    
    // MARK: set the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate and data source
        accountTableView.delegate = self
        accountTableView.dataSource = self
        
        // register custom cell content
        accountTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        // register custom cell for header
        accountTableView.register(UINib(nibName: "AccountHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "accountHeaderCell")
        accountTableView.tableFooterView = UIView()
        
    }
    
    // MARK: - Set tableview
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkStatus() {
            return 1
        } else {
            return menu.count
        }
    }
    
    // set item on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if checkStatus() {
            // if user have not log in
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCell", for: indexPath)
            cell.textLabel?.text = "Click here to login!"
            accountTableView.rowHeight = 150.0
            accountTableView.separatorStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
            cell.accountSetting.text = menu[indexPath.row]
            accountTableView.rowHeight = 70.0
            return cell
        }
    }
    
    // set header content
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountHeaderCell") as! AccountHeaderTableViewCell
        if checkStatus() {
            cell.accountName.text = "please login to continue"
            cell.accountProfilePicture.image = UIImage(named: "imagetest")
            return cell
        } else {
            cell.accountName.text = "you are login"
            cell.accountProfilePicture.image = UIImage(named: "imagetest")
            return cell
        }
    }
    
    // set header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkStatus() {
            identifier = 1
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }

    // MARK: - Function to check if user login
    func checkStatus() -> Bool {
        let accountResult = realm.objects(Account.self)
        if accountResult.count == 0 {
            return true
        } else {
            return false
        }
    }
    
}
