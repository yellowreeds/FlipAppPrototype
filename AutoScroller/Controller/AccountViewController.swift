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
    
    // MARK: - HOLD REALM
    var accountResult: Results<Account>?
    
    // MARK: - VARIABLES FOR TABLE HEADER
    var useremail: String = ""
    var username: String = ""
    var profilePicture: String = ""
    
    // MARK: - IBOUTLET
    @IBOutlet weak var accountTableView: UITableView!
    
    // MARK: - INIT REALM
    let realm = try! Realm()
    
    // MARK: - INIT MENU AND ICON
    let menu = ["Account", "Edit Profile", "Help", "Logout"]
    let menuIcon = ["accountsetting", "accountedit", "help", "logout"]
    
    // MARK: - VARIABLES FOR IDENTIFICATION
    var identifier = 0
    var status = false

    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountTableView.reloadData()
        
    }
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        accountResult = realm.objects(Account.self)
        // set delegate and data source
        accountTableView.delegate = self
        accountTableView.dataSource = self
        
        
        // register custom cell content
        accountTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        // register custom cell for header
        accountTableView.register(UINib(nibName: "AccountHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "accountHeaderCell")
        accountTableView.tableFooterView = UIView()
        
    }
    
    // MARK: - TABLE VIEW
    // set number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accountResult!.count < 1 {
            return 1
        } else {
            return menu.count
        }
    }
    
    // set item on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if accountResult!.count < 1 {
            // user no login
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCell", for: indexPath)
            cell.textLabel?.text = "Click here to login!"
            accountTableView.rowHeight = 150.0
            accountTableView.separatorStyle = .none
            return cell
        } else {
            // user login
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
            cell.accountSetting.text = menu[indexPath.row]
            cell.imageAccount.image = UIImage(named: menuIcon[indexPath.row])
            accountTableView.rowHeight = 70.0
            return cell
        }
    }
    
    // set header content
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountHeaderCell") as! AccountHeaderTableViewCell
        if accountResult!.count < 1 {
            // user no login
            cell.accountName.text = "Please Login to Continue"
            cell.accountEmail.text = ""
            let url = URL(string: "https://amentiferous-grass.000webhostapp.com/assets/img/avatar/default.jpg")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                cell.accountProfilePicture.image = UIImage(data: imageData)
            }
            return cell
        } else {
            //user login
            accountResult = realm.objects(Account.self)
            cell.accountName.text = accountResult?[0].fullName
            cell.accountEmail.text = accountResult?[0].username
            let url = URL(string: (accountResult?[0].avatar)!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                cell.accountProfilePicture.image = UIImage(data: imageData)
            }
            return cell
        }
    }
    
    // set header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if accountResult!.count < 1 {
            identifier = 1
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            if indexPath.row == 3 {
                
                // create the alert
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    self.accountResult = self.realm.objects(Account.self)
                    do {
                        try self.realm.write {
                            self.realm.deleteAll()
                        }
                    } catch {
                        print("Error write realm, \(error)")
                    }
                    self.status = false
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! LoginViewController
        destinationViewController.status = false
    }
}
