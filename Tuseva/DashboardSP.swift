
//
//  DashboardSC.swift
//  Tuseva
//
//  Created by Praveen Khare on 08/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DashboardSP: UIViewController {

    @IBOutlet var collection_view: UICollectionView!
    
    var imgArr : [UIImage] = [UIImage(named: "dash1")!,UIImage(named: "dash2")!,UIImage(named: "dash3")!,UIImage(named: "dash4")!,UIImage(named: "dash5")!,UIImage(named: "dash6")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection_view.delegate = self
        collection_view.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        width = width - 10
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection_view!.collectionViewLayout = layout
    }

}

extension DashboardSP : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection_view.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CellForColletionView
        cell.imgView.image = imgArr[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let padding =  10
//        let collectionViewSize = Int(collection_view.frame.size.width) - padding
//        
//        return CGSize(width: CGFloat(collectionViewSize/2), height: CGFloat(collectionViewSize/2))

        let photo =  imgArr[indexPath.row]
        return CGSize(width: collection_view.frame.size.width/2 - 20, height: (photo.size.height))
    }
}

class CellForColletionView : UICollectionViewCell{

    @IBOutlet var imgView: UIImageView!
}
