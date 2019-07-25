//
//  AppDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 26/06/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
import Alamofire

class AppDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Initialize variables to display label
    var appID = "", appTitle = "", appCat = "", appDesc = "", appPrice = 0, appImage = "", imgArr: [String] = []
    
    // MARK: - Initilalize IBOutlet
    @IBOutlet weak var forCategory: UILabel!
    @IBOutlet weak var forTitle: UILabel!
    @IBOutlet weak var forPrice: UILabel!
    @IBOutlet weak var forDesc: UITextView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var accountResult: Results<Account>?
    var userid: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        accountResult = realm.objects(Account.self)
        if accountResult!.count > 0 {
            if let account = accountResult?[0] {
                userid = account.userID
                print("user id: \(userid)")
            }
        }
    }
    
    
    // MARK: - Initialize Realm
    let realm = try! Realm()
    
    // MARK: - Initialize variables for slideshow
    var timer = Timer()
    var counter = 0, tag = 0
    
    // MARK: - Set the view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the slideshow
        // set number of photos
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        
        // set image changer asynchronously
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        // set the delegate and data source
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        // set the frame size
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        // set the variables to dislay label
        forTitle.text = appTitle
        forDesc.text = appDesc
        forPrice.text = String(appPrice)
        forCategory.text = appCat
    }
    
    // MARK: - Function when add to cart is pressed
    @IBAction func addToCartPressed(_ sender: Any) {
        let url = "https://amentiferous-grass.000webhostapp.com/api/cart"
        let parameters: Parameters = ["fliptoken" : "flip123", "user_id" : userid, "app_id" : appID]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("ini hasil response data: \(response.result)")
            } else {
                print("Error \(response.result.error)")
            }
        }
        
        do {
            try self.realm.write {
                if checkEmptyCart() {
                    // check if Cart is empty
                    let newItem = Cart()
                    newItem.name = appTitle
                    newItem.category = appCat
                    newItem.price = String(appPrice)
                    newItem.desc = appDesc
                    newItem.icon = appImage
                    newItem.poster1 = imgArr[0]
                    newItem.poster2 = imgArr[1]
                    newItem.poster3 = imgArr[2]
                    realm.add(newItem)
                    
                    showAlertUI(headTitle: "Sucessfully Added", message: "This product is successfully added to your cart", title: "OK")
                } else {
                    let result = checkInsideWishlist()
                    if result {
                        // check if items already added to Wishlist
                        showAlertUI(headTitle: "Already Added", message: "This product already added to your cart", title: "OK")
                    } else {
                        let newItem = Cart()
                        newItem.name = appTitle
                        newItem.category = appCat
                        newItem.price = String(appPrice)
                        newItem.desc = appDesc
                        newItem.icon = appImage
                        newItem.poster1 = imgArr[0]
                        newItem.poster2 = imgArr[1]
                        newItem.poster3 = imgArr[2]
                        realm.add(newItem)
                        
                        showAlertUI(headTitle: "Successfully Added", message: "This product is successfully added to your cart", title: "OK")
                    }
                }
            }
        } catch {
            print("Error write realm, \(error)")
        }
    }

    // function to check if same data exists
    func checkInsideCart() -> Bool {
        let cartResult = realm.objects(Cart.self)
        for n in 0...cartResult.count-1 {
            if cartResult[n].name == appTitle && cartResult[n].category == appCat {
                return true
            }
        }
        return false
    }
    
    // function to check if data is empty
    func checkEmptyCart() -> Bool {
        let cartResult = realm.objects(Cart.self)
        if cartResult.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Function to show alert UI
    func showAlertUI(headTitle: String, message: String, title: String) {
        // create the alert
        let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Function when add to wishlist is pressed
    @IBAction func addToWishlistPressed(_ sender: Any) {
        let url = "https://amentiferous-grass.000webhostapp.com/api/wishlist"
        let parameters: Parameters = ["fliptoken" : "flip123", "user_id" : userid, "app_id" : appID]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("ini hasil response data: \(response.result)")
            } else {
                print("Error \(response.result.error)")
            }
        }
        
        do {
            try self.realm.write {
                if checkEmptyWishlist() {
                    // check if Wishlist is empty
                    let newItem = Wishlist()
                    newItem.name = appTitle
                    newItem.category = appCat
                    newItem.price = String(appPrice)
                    newItem.desc = appDesc
                    newItem.icon = appImage
                    newItem.poster1 = imgArr[0]
                    newItem.poster2 = imgArr[1]
                    newItem.poster3 = imgArr[2]
                    realm.add(newItem)
                    
                    showAlertUI(headTitle: "Sucessfully Added", message: "This product is successfully added to your wishlist", title: "OK")
                } else {
                    let result = checkInsideWishlist()
                    if result {
                        // check if items already added to Wishlist
                        showAlertUI(headTitle: "Already Added", message: "This product already added to your wishlist", title: "OK")
                    } else {
                        let newItem = Wishlist()
                        newItem.name = appTitle
                        newItem.category = appCat
                        newItem.price = String(appPrice)
                        newItem.desc = appDesc
                        newItem.icon = appImage
                        newItem.poster1 = imgArr[0]
                        newItem.poster2 = imgArr[1]
                        newItem.poster3 = imgArr[2]
                        realm.add(newItem)
                        
                        showAlertUI(headTitle: "Successfully Added", message: "This product is successfully added to your wishlist", title: "OK")
                    }
                }
            }
        } catch {
            print("Error write realm, \(error)")
        }
    }
    
    // function to check if same data exists
    func checkInsideWishlist() -> Bool {
        let wishlistResult = realm.objects(Wishlist.self)
        for n in 0...wishlistResult.count-1 {
            if wishlistResult[n].name == appTitle && wishlistResult[n].category == appCat {
                return true
            }
        }
        return false
    }
   
    // function to check if data is empty
    func checkEmptyWishlist() -> Bool {
        let wishlistResult = realm.objects(Wishlist.self)
        if wishlistResult.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Function to change image in slideshow
    @objc func changeImage() {
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    // MARK: - Set the collection view for slideshow
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
    }
    
    // photo on each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                let url = URL(string: imgArr[indexPath.row])
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    vc.image = UIImage(data: imageData)
                }
            }
        
            // MARK: Set the container for slideshow
            // set edge inset
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        
            // set frame size
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = sliderCollectionView.frame.size
                return CGSize(width: size.width, height: size.height)
            }
        
            // set minimum line spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
            }
        
            // set minimum inter item spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
        }
            return cell
    }
}
