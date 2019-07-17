//
//  AppDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 26/06/19.
//  Copyright © ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class AppDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var appTitle = "", appCat = "", appDesc = "", appPrice = 0, appImage = ""
    
    @IBOutlet weak var forCategory: UILabel!
    @IBOutlet weak var forTitle: UILabel!
    @IBOutlet weak var forPrice: UILabel!
    @IBOutlet weak var forDesc: UITextView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let realm = try! Realm()
    
    var imgArr: [String] = []
    
    var timer = Timer()
    var counter = 0, tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        forTitle.text = appTitle
        forDesc.text = appDesc
        forPrice.text = String(appPrice)
        forCategory.text = appCat
        
    }
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
        print("ditekan ke cart \(appTitle), \(appDesc), \(appPrice)")
        do {
            try self.realm.write {
                if checkEmptyCart() {
                    let newItem = Cart()
                    newItem.name = appTitle
                    newItem.category = appCat
                    newItem.price = String(appPrice)
                    newItem.desc = appDesc
                    realm.add(newItem)
                    
                    // create the alert
                    let alert = UIAlertController(title: "Successfully Added", message: "This product is successfully added to your cart.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let result = checkInsideCart()
                    if result {
                        // create the alert
                        let alert = UIAlertController(title: "Already added", message: "This product already added to your cart", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let newItem = Cart()
                        newItem.name = appTitle
                        newItem.category = appCat
                        newItem.price = String(appPrice)
                        newItem.desc = appDesc
                        realm.add(newItem)
                        
                        let alert = UIAlertController(title: "Successfully Added", message: "This product is successfully added to your cart.", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print("Error write realm, \(error)")
        }
    }

    @IBAction func addToWishlistPressed(_ sender: Any) {
        do {
            try self.realm.write {
                if checkEmptyWishlist() {
                    let wishlistResult = realm.objects(Wishlist.self)
                    let newItem = Wishlist()
                    newItem.name = appTitle
                    newItem.category = appCat
                    newItem.price = String(appPrice)
                    newItem.desc = appDesc
                    newItem.icon = appImage
                    realm.add(newItem)
                    
                    // create the alert
                    let alert = UIAlertController(title: "Successfully Added", message: "This product is successfully added to your wishlist", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let result = checkInsideWishlist()
                    if result {
                        // create the alert
                        let alert = UIAlertController(title: "Already added", message: "This product already added to your wishlist", preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let newItem = Wishlist()
                        newItem.name = appTitle
                        newItem.category = appCat
                        newItem.price = String(appPrice)
                        newItem.desc = appDesc
                        newItem.icon = appImage
                        realm.add(newItem)
                        
                        let alert = UIAlertController(title: "Successfully Added", message: "This product is successfully added to your wishlist", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print("Error write realm, \(error)")
        }
    }
    
    func checkInsideWishlist() -> Bool {
        let wishlistResult = realm.objects(Wishlist.self)
        for n in 0...wishlistResult.count-1 {
            if wishlistResult[n].name == appTitle && wishlistResult[n].category == appCat {
                return true
            }
        }
        return false
    }
    
    func checkInsideCart() -> Bool {
        let cartResult = realm.objects(Cart.self)
        for n in 0...cartResult.count-1 {
            if cartResult[n].name == appTitle && cartResult[n].category == appCat {
                return true
            }
        }
        return false
    }
    
    func checkEmptyCart() -> Bool {
        let cartResult = realm.objects(Cart.self)
        if cartResult.count == 0 {
            return true
        } else {
            return false
        }
    }
   
    func checkEmptyWishlist() -> Bool {
        let wishlistResult = realm.objects(Wishlist.self)
        if wishlistResult.count == 0 {
            return true
        } else {
            return false
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                let url = URL(string: imgArr[indexPath.row])
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    vc.image = UIImage(data: imageData)
                }
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = sliderCollectionView.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
        }
            return cell
    }
}
