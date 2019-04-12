//
//  DashboardCDViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 10/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DashboardCDViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {

    @IBOutlet var collView: UICollectionView!
    
    var imgArr : [UIImage] = [UIImage(named: "dash1")!,UIImage(named: "dash2")!,UIImage(named: "dash3")!,UIImage(named: "dash4")!,UIImage(named: "dash5")!,UIImage(named: "dash6")!]
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for i in self.imgArr {
            
            let img : UIImage = i
            _cellSizes.append(CGSize(width: self.collView.frame.size.width / 2, height: img.size.height + 80))
        }
        
        return _cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        collView.backgroundColor = UIColor.lightGray
        
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.headerInset = UIEdgeInsetsMake(20, 0, 0, 0)
//        layout.headerHeight = 50
//        layout.footerHeight = 20
//        layout.minimumColumnSpacing = 10
//        layout.minimumInteritemSpacing = 10
        
        collView.collectionViewLayout = layout

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cellForColletionViewCD
        cell.cellImageView.image = imgArr[indexPath.item]

        print("HEIGHT--\(cell.frame.size.height)")
        print("WIDTH--\(cell.frame.size.width)")
        
//        cell.layer.cornerRadius = 10
//        cell.layer.shadowRadius = 5
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
//        cell.layer.opacity = 0.5

        cell.imgHeight.constant = imgArr[indexPath.item].size.height
        cell.viewHeight.constant = 80
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
//    func collectionView(collView: UICollectionView, willDisplay cell: cellForColletionViewCD, forItemAt indexPath: IndexPath) {
//        
//            }
}

class cellForColletionViewCD: UICollectionViewCell {
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var detailedView: UIView!
    @IBOutlet var lblCarName: UILabel!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
}
