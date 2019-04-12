//
//  DashboardCollectionViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 09/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import AVFoundation

class DashboardCollectionViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {

    @IBOutlet var collection_view: UICollectionView!
    
    @IBAction func btnQueryClk(_ sender: Any)
    {
        let queryVC = self.storyboard?.instantiateViewController(withIdentifier: "MyQueryRPSViewController") as! MyQueryRPSViewController
        self.navigationController?.pushViewController(queryVC, animated: true)

    }
    @IBAction func btnResponseClk(_ sender: Any)
    {
        let queryVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateQueryViewController") as! CreateQueryViewController
        self.navigationController?.pushViewController(queryVC, animated: true)
    }
    var imgArr : [UIImage] = [UIImage(named: "dash1")!,UIImage(named: "dash2")!,UIImage(named: "dash3")!,UIImage(named: "dash4")!,UIImage(named: "dash5")!,UIImage(named: "dash6")!]
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for i in self.imgArr {
            
            let img : UIImage = i
            _cellSizes.append(CGSize(width: self.collection_view.frame.size.width / 2, height: img.size.height + 80))
        }
        
        return _cellSizes
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //        layout.headerInset = UIEdgeInsetsMake(20, 0, 0, 0)
        //        layout.headerHeight = 50
        //        layout.footerHeight = 20
        //        layout.minimumColumnSpacing = 10
        //        layout.minimumInteritemSpacing = 10
        
        collection_view.collectionViewLayout = layout
      
    }

    override func viewWillAppear(_ animated: Bool)
    {
            self.navigationController?.navigationBar.isHidden = false
        
            let filterImage   = UIImage(named: "setting")!
            let navUserImage = UIImage(named: "backbtn")!
            
            let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(DashboardCollectionViewController.didTapFilterButton(sender:)))
            
            let menuBtn = UIBarButtonItem(image: navUserImage, landscapeImagePhone: navUserImage, style: .plain, target: self, action: #selector(DashboardCollectionViewController.didTapMenuButton(sender:)))
        
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
            navigationItem.leftBarButtonItem = backButton
            
            self.navigationItem.title = "Dashboard"
            self.navigationItem.rightBarButtonItem = filterBtn
            self.navigationItem.leftBarButtonItem = menuBtn
    
    }
  
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func didTapMenuButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)

        
    }
    
    func didTapFilterButton(sender: AnyObject){
        
        print("Filter btn tapped")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection_view.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cellForColletionViewSP
        cell.cellImageView.image = imgArr[indexPath.item]
        
        print("HEIGHT--\(cell.frame.size.height)")
        print("WIDTH--\(cell.frame.size.width)")
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 0.5
        cell.layer.shadowOpacity = 0.20
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.imgHeight.constant = imgArr[indexPath.item].size.height
        cell.viewHeight.constant = 80
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let queryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "QueryDetailSPViewController") as! QueryDetailSPViewController
        
        self.navigationController?.pushViewController(queryDetailVC, animated: true)
    }

}

class cellForColletionViewSP: UICollectionViewCell {
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var detailedView: UIView!
    @IBOutlet var lblCarName: UILabel!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
}



