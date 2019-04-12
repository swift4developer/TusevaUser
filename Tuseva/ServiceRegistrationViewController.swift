//
//  ServiceRegistrationViewController.swift
//  Tuseva
//
//  Created by oms183 on 8/12/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class ServiceRegistrationViewController: UIViewController {

    @IBOutlet var collView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false

        let filterImage   = UIImage(named: "setting")!
        let navUserImage = UIImage(named: "menu")!
        
        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ServiceRegistrationViewController.didTapFilterButton(sender:)))
        
        let menuBtn = UIBarButtonItem(image: navUserImage, landscapeImagePhone: navUserImage, style: .plain, target: self, action: #selector(ServiceRegistrationViewController.didTapMenuButton(sender:)))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Service Registration"
        self.navigationItem.rightBarButtonItem = filterBtn
        self.navigationItem.leftBarButtonItem = menuBtn
        
    }
    
    func didTapBackButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func didTapMenuButton(sender: AnyObject){
        
        self.revealViewController().revealToggle(sender)
        
    }
    
    func didTapFilterButton(sender: AnyObject){
        
        print("Filter btn tapped")
    }
}

extension ServiceRegistrationViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cellServiceRegistration
        cell.lblVehicleDetails.text = "Splendar+"
//        
//        cell.contentView.backgroundColor = UIColor.clear
//        cell.contentView.layer.cornerRadius = 5
//        cell.contentView.layer.borderWidth = 1.0
//        
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//        
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        cell.layer.shadowRadius = 2.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

class cellServiceRegistration : UICollectionViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblVehicleDetails: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var imgUser: UIImageView!
}
