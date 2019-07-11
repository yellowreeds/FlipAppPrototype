//
//  AppDetailViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 26/06/19.
//  Copyright © ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import RealmSwift

class AppDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var appTitle = "", appCat = "", appDesc = "", appPrice = 0
    
    @IBOutlet weak var forCategory: UILabel!
    @IBOutlet weak var forTitle: UILabel!
    @IBOutlet weak var forDesc: UILabel!
    @IBOutlet weak var forPrice: UILabel!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let realm = try! Realm()
    
    var imgArr = [  UIImage(named:"image1"),
                    UIImage(named:"image2"),
                    UIImage(named:"image3")
    ]
    
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
        
        print("print label: \(appTitle)")
    }
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
        print("ditekan ke cart \(appTitle), \(appDesc), \(appPrice)")
        
        
    }
    
    
    @IBAction func addToWishlistPressed(_ sender: Any) {
        print("ditekan ke wishlist \(appTitle), \(appDesc), \(appPrice)")
        do {
            try self.realm.write {
                //additem
                if realm.isEmpty {
                    print("jika kosong")
                    let newItem = Wishlist()
                    newItem.name = appTitle
                    newItem.category = appCat
                    newItem.price = String(appPrice)
                    realm.add(newItem)
                    
                    let alert = UIAlertController(title: "Successfully Added", message: "This product is successfully added to your wishlist", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let result = checkInside()
                    if result {
                        print("Jika ada isinya")
                        // create the alert
                        let alert = UIAlertController(title: "Already added", message: "This product already added to your wishlist", preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Jika tidak ada isinya")
                        let newItem = Wishlist()
                        newItem.name = appTitle
                        newItem.category = appCat
                        newItem.price = String(appPrice)
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
    
    func checkInside() -> Bool {
        let wishlistResult = realm.objects(Wishlist.self)
        print("jika isi dari wishlist count\(wishlistResult.count)")
        for n in 0...wishlistResult.count-1 {
            if wishlistResult[n].name == appTitle && wishlistResult[n].category == appCat {
                return true
            }
        }
        return false
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
            return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.image = imgArr[indexPath.row]
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
