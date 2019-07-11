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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var midCollection: UICollectionView!
    
    let DATA_URL = "http://api-flipapp.epizy.com/product?flippAppKey=flipp123"
    
    
    let imgArr = [  UIImage(named:"image1"),
                    UIImage(named:"image2"),
                    UIImage(named:"image3")
    ]
    
    let appName = ["Name1", "Name2", "Name3", "Name4", "Name5", "Name6", "Name7", "Name8", "Name9", "Name10", "Name11"
    ]
    
    let appDescription = ["Desc1", "Desc2", "Desc3", "Desc4", "Desc5", "Desc6", "Desc7", "Desc8", "Desc9", "Desc10", "Desc11"]
    
    let appPrice = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000
    ]
    
    let appCat = ["category1", "category1", "category2", "category3", "category2", "category5", "category2", "category1", "category4", "category4", "category3"]
    
    
    
    var timer = Timer()
    var counter = 0, tag = 0
    var labelTitle = "", labelDetail = "", labelPrice = 0, labelCategory = "", identifier2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        sliderCollectionView.delegate = self
        topCollection.delegate = self
        midCollection.delegate = self
        midCollection.dataSource = self
        sliderCollectionView.dataSource = self
        topCollection.dataSource = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        //let params : [String:String] = ["flippAppKey" : "flipp123"]
        
        //getData(url: DATA_URL)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getData(url : String) {
//        Alamofire.request(url).responseString { response in
//            print("Success: \(response.result.isSuccess)")
//            print("Response String: \(response.result.value)")
//        }
//
//
//        Alamofire.request(url, method: .get).responseJSON {
//            response in
//            if response.result.isSuccess {
//                print("Success! Got a weather data")
//
//                let weatherJSON : JSON = JSON(response.result.value!)
//                print(weatherJSON)
//                //self.updateWeatherData(json: weatherJSON)
//
//            } else {
//                print("Error: \(response.result.error)")
//                //self.cityLabel.text = "Connection Issues"
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailApp" {
            let nextVC = segue.destination as! AppDetailViewController
            nextVC.appTitle = labelTitle
            nextVC.appDesc = labelDetail
            nextVC.appPrice = labelPrice
            nextVC.appCat = labelCategory
        } else if segue.identifier == "summaryApp" {
            let nextVC = segue.destination as! SummaryDetailViewController
            
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
        labelTitle = appName[(sender as AnyObject).tag!]
        labelDetail = appDescription[(sender as AnyObject).tag!]
        labelPrice = appPrice[(sender as AnyObject).tag!]
        labelCategory = appCat[(sender as AnyObject).tag!]
        performSegue(withIdentifier: "detailApp", sender: self)
    }
    
    @IBAction func topRatedApp(_ sender: Any) {
        labelTitle = appName[(sender as AnyObject).tag!]
        labelDetail = appDescription[(sender as AnyObject).tag!]
        labelPrice = appPrice[(sender as AnyObject).tag!]
        labelCategory = appCat[(sender as AnyObject).tag!]
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
            return appName.count
        }
        return appName.count    
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
            editButton.setImage(UIImage(named: "imagetest.png"), for: .normal)
            
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
            editButton.setImage(UIImage(named: "imagetest.png"), for: .normal)
            
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
