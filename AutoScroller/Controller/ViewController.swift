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

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var midCollection: UICollectionView!

    var productJSON : JSON?
    
    var productCount: Int = 0
    
    let imgArr = [  UIImage(named:"image1"),
                    UIImage(named:"image2"),
                    UIImage(named:"image3")
    ]
    
    var timer = Timer()
    var counter = 0, tag = 0, toDetail = 0
    var labelTitle = "", labelDetail = "", labelPrice = 0, labelCategory = "", identifier2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        passData()
        self.view.makeToastActivity(.center)

        if productCount > 0 {
            print("Test")
            self.view.hideToastActivity()
        }

        
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        DispatchQueue.main.async {
            self.topCollection.reloadData()
            self.midCollection.reloadData()
        }
        
        sliderCollectionView.delegate = self
        topCollection.delegate = self
        midCollection.delegate = self
        midCollection.dataSource = self
        sliderCollectionView.dataSource = self
        topCollection.dataSource = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        Alamofire.request("https://amentiferous-grass.000webhostapp.com/api/app?fliptoken=flipp123", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("SUKSES")
                self.productJSON = JSON(response.result.value!)
                self.productCount = self.productJSON!["data"].count
                print(self.productCount)
                let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
                let vc = navController.topViewController as! CategoryViewController
                vc.productJSON = self.productJSON!["data"]
                
            } else {
                print("Error: \(response.result.error)")
            }
        }
    }
    
    
    func passData() {
        let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! CategoryViewController
        vc.productJSON = productJSON
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailApp" {
            let nextVC = segue.destination as! AppDetailViewController
            nextVC.appTitle = labelTitle
            nextVC.appDesc = labelDetail
            nextVC.appPrice = labelPrice
            nextVC.appCat = labelCategory
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto1"])")
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto2"])")
            nextVC.imgArr.append("\(productJSON!["data"][toDetail]["app_foto3"])")
        } else if segue.identifier == "summaryApp" {
            let nextVC = segue.destination as! SummaryDetailViewController
            nextVC.productJSON = productJSON
            nextVC.identifier = identifier2
        }
    }    
    
    @IBAction func topApplication(_ sender: Any) {
        identifier2 = 2
        performSegue(withIdentifier: "summaryApp", sender: self)
    }
    
    @IBAction func topRated(_ sender: Any) {
        identifier2 = 3
        performSegue(withIdentifier: "summaryApp", sender: self)
    }
    
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
        toDetail = (sender as AnyObject).tag!
        print("ini toDetail: \(toDetail)")
        performSegue(withIdentifier: "detailApp", sender: self)
    }
    
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
        performSegue(withIdentifier: "detailApp", sender: self)
        
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
        if collectionView == self.sliderCollectionView {
            return imgArr.count
        } else if collectionView == self.topCollection {
            sleep(2)
            return productCount
        }
        sleep(2)
        return productCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.sliderCollectionView {
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
        } else if collectionView == self.topCollection {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "topCollection", for: indexPath)
            
            let editButton = UIButton(frame: CGRect(x:0, y:0, width:90,height:90))
           
            editButton.tag = indexPath.row
        
            let url = URL(string:"\(productJSON!["data"][indexPath.row]["app_foto"])" )
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                editButton.setImage(UIImage(data: imageData), for: .normal)
            }
            
            editButton.addTarget(self, action: #selector(topAppDetail), for: UIControl.Event.touchUpInside)
            
            cellB.addSubview(editButton)
            
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = topCollection.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            
            func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            return cellB
        } else {
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "midCollection", for: indexPath)
            
            let editButton = UIButton(frame: CGRect(x:0, y:0, width:90,height:90))
            
            editButton.tag = indexPath.row
            
            let url = URL(string:"\(productJSON!["data"][indexPath.row]["app_foto"])" )
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                editButton.setImage(UIImage(data: imageData), for: .normal)
            }
            
            editButton.addTarget(self, action: #selector(topRatedApp), for: UIControl.Event.touchUpInside)
            
            cellC.addSubview(editButton)
            
            
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                let size = midCollection.frame.size
                return CGSize(width: size.width, height: size.height)
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            
            func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1.0
            }
            return cellC
        }
    }
    
    
    
}
