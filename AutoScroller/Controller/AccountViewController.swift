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

    @IBOutlet weak var accountTableView: UITableView!
    
    let realm = try! Realm()
    
    let menu = ["Account", "Edit Profile", "Help", "Logout", "Testing baru"]
    
    var identifier = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        accountTableView.register(UINib(nibName: "AccountHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "accountHeaderCell")
        accountTableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkStatus() {
            return 1
        } else {
            return menu.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if checkStatus() {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkStatus() {
            identifier = 1
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    func checkStatus() -> Bool {
        let accountResult = realm.objects(Account.self)
        if accountResult.count == 0 {
            return true
        } else {
            return false
        }
    }
    
}
