//
//  ViewController.swift
//  AutoScroller
//
//  Created by Aria Bisma Wahyutama on 23/06/19.
//  Copyright © 2019 ARIA BISMA WAHYUTAMA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Set IBOulet
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var midCollection: UICollectionView!
    
    // MARK: - Set variable for JSON and count data from JSON
    var productJSON : JSON?
    var productCount: Int = 0
    
    
    
    // MARK: - Set variable for slide show images, counter and the duration
    let imgArr: [String] =  ["http://localhost/flipapp/assets/img/poster/default.jpg",
                             "http://localhost/flipapp/assets/img/poster/default.jpg",
                             "http://localhost/flipapp/assets/img/poster/default.jpg"]
    var timer = Timer()
    var counter = 0
    
    
    // MARK: - Set variables to identify which app is selected
    var tag = 0, toDetail = 0
    
    
    // MARK: - Set variables for label that goes to AppDetailViewController
    var labelTitle = "", labelDetail = "", picture = "", labelPrice = 0, labelCategory = ""
    
    // MARK: - Set variables for identifer to AppDetailViewController and SummaryDetailViewController
    var identifier2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Setting homescreen
        // get data from API
        getData()
        
        // create toast activity to wait for API to load
        self.view.makeToastActivity(.center)
        
        // configure the picture slide show
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        // reload the collectionview asynchronously
        DispatchQueue.main.async {
            self.topCollection.reloadData()
            self.midCollection.reloadData()
        }
        
        // set delegate to the collection view
        sliderCollectionView.delegate = self
        topCollection.delegate = self
        midCollection.delegate = self
        
        // set the data source for the collection view
        midCollection.dataSource = self
        sliderCollectionView.dataSource = self
        topCollection.dataSource = self
        
        // set the page height so it is able to scroll
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

    }

    // MARK: - Function to get data from JSON
    func getData() {
        Alamofire.request("https://amentiferous-grass.000webhostapp.com/api/app?fliptoken=flipp123", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.productJSON = JSON(response.result.value!)
                self.productCount = self.productJSON!["data"].count
                
                // to hide toast activity if json is fully loaded.
                if self.productCount > 0 {
                    self.view.hideToastActivity()
                }
                
                self.sendToCategoryViewController()
                self.sendToWishlistViewController()
                
            } else {
                print("Error: \(response.result.error)")
            }
        }
    }
    
    
    // MARK: - Functions to send JSON to another controller
    // to category
    func sendToCategoryViewController() {
        let navControllerCategory = self.tabBarController!.viewControllers![1] as! UINavigationController
        let toControllerCategory = navControllerCategory.topViewController as! CategoryViewController
        toControllerCategory.productJSON = productJSON!["data"]
    }
    
    // to wishlist
    func sendToWishlistViewController() {
        let navControllerWishlist = self.tabBarController!.viewControllers![2] as! UINavigationController
        let toControllerWishlist = navControllerWishlist.topViewController as! WishlistViewController
        toControllerWishlist.productJSON = productJSON!["data"]
    }
    
    // MARK: - Function to prepare segue to AppDetailViewController and SummaryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailApp" {
            // if user click the app
            let nextVC = segue.destination as! AppDetailViewController
            nextVC.appTitle = labelTitle
            nextVC.appDesc = labelDetail
            nextVC.appPrice = labelPrice
            nextVC.appCat = labelCategory
            nextVC.appImage = picture
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto1"])")
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto2"])")
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto3"])")
        } else if segue.identifier == "summaryApp" {
            // if user click see all button
            let nextVC = segue.destination as! SummaryDetailViewController
            nextVC.productJSON = productJSON
            print("ini nextVC.productJSON \(nextVC.productJSON)")
            nextVC.identifier = identifier2
        }
    }
    
    // MARK: - Function when button is pressed
    // when See All in top application is pressed
    @IBAction func topApplication(_ sender: Any) {
        identifier2 = 2
        performSegue(withIdentifier: "summaryApp", sender: self)
    }
    
    // when See All in top rated is pressed
    @IBAction func topRated(_ sender: Any) {
        identifier2 = 3
        performSegue(withIdentifier: "summaryApp", sender: self)
    }
    
    // when product in top application is pressed
    @IBAction func topAppDetail(_ sender: Any) {
        labelTitle = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_name"])"
        labelDetail = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_desc"])"
        labelPrice = Int("\(productJSON!["data"][(sender as AnyObject).tag!]["app_harga"])")!
        if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "2" {
            labelCategory = "Contacts"
        } else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "3" {
            labelCategory = "Locations"
        } else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "5" {
            labelCategory = "Storage"
        }  else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "11" {
            labelCategory = "Android/IOS"
        }  else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "13" {
            labelCategory = "Smart Home"
        } else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "0" {
            labelCategory = "Kategori belum ditentukan"
        }
        picture = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_foto"])"
        toDetail = (sender as AnyObject).tag!
        performSegue(withIdentifier: "detailApp", sender: self)
    }
    
    
    // when product in top rated is pressed
    @IBAction func topRatedApp(_ sender: Any) {
        labelTitle = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_name"])"
        labelDetail = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_desc"])"
        labelPrice = Int("\(productJSON!["data"][(sender as AnyObject).tag!]["app_harga"])")!
        if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "2" {
            labelCategory = "Contacts"
        } else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "3" {
            labelCategory = "Locations"
        } else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "5" {
            labelCategory = "Storage"
        }  else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "11" {
            labelCategory = "Android/IOS"
        }  else if "\(productJSON!["data"][(sender as AnyObject).tag!]["category_id"])" == "13" {
            labelCategory = "Smart Home"
        }
        picture = "\(productJSON!["data"][(sender as AnyObject).tag!]["app_foto"])"
        performSegue(withIdentifier: "detailApp", sender: self)
        
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
    
    
    // MARK: - Set up the collection view
    // function to set how many items in slide show, top rated, and top application
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.sliderCollectionView {
            return imgArr.count
        } else if collectionView == self.topCollection {
            sleep(2)
            return productCount
        }
        sleep(2)
        return productCount
    }
    
    //to set element on each cell on collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.sliderCollectionView {
            // MARK: Set up for slideshow
            // for pictures
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                
                let url = URL(string: imgArr[indexPath.row])
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    vc.image = UIImage(data: imageData)
                }
            }
            
            // for edge inset
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            // for size
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = sliderCollectionView.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            // for line spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
            }
            
            // for inter item spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0.0
            }
            return cell
        } else if collectionView == self.topCollection {
            // MARK: - Set up the top application
            // to set cell
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "topCollection", for: indexPath)
            
            // initialize button
            let editButton = UIButton(frame: CGRect(x:0, y:0, width:90,height:90))
            editButton.tag = indexPath.row
            
            // add image to button
            let url = URL(string:"\(productJSON!["data"][indexPath.row]["app_foto"])" )
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                editButton.setImage(UIImage(data: imageData), for: .normal)
            }
            
            // add event to button
            editButton.addTarget(self, action: #selector(topAppDetail), for: UIControl.Event.touchUpInside)
            
            // add button to view
            cellB.addSubview(editButton)
            
            // set size for frame
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = topCollection.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            // set minimum inter item spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            
            // minimum line spacing
            func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            return cellB
        } else {
            // MARK: - Set up the top rated
            // set cell
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "midCollection", for: indexPath)
            
            // initialize button
            let editButton = UIButton(frame: CGRect(x:0, y:0, width:90,height:90))
            editButton.tag = indexPath.row
            
            // add image to button
            let url = URL(string:"\(productJSON!["data"][indexPath.row]["app_foto"])" )
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                editButton.setImage(UIImage(data: imageData), for: .normal)
            }

            // add event to button
            editButton.addTarget(self, action: #selector(topRatedApp), for: UIControl.Event.touchUpInside)
            
            // add button to view
            cellC.addSubview(editButton)
            
            // set size
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = midCollection.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            // set minimum inter item spacing
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            
            // set minimun line spacing
            func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            return cellC
        }
    } 
}
