

//
//  MyProfileSC.swift
//  Tuseva
//
//  Created by Praveen Khare on 05/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class MyProfileSP: UIViewController {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var txtServiceStationName: UITextField!
    
    @IBOutlet var txtMobile: UITextField!
    
    @IBOutlet var txtEmailId: UITextField!
    
    @IBOutlet var txtAddress: UITextField!
    
    
    
    @IBAction func btnAddPhoto(_ sender: Any) {
    }
    @IBAction func brnRatingClk(_ sender: Any)
    {
        let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: "Rating_ReviewViewController") as! Rating_ReviewViewController
        self.navigationController?.pushViewController(ratingVC, animated: true)
    }
    @IBAction func btnContactClk(_ sender: Any)
    {
        let mobileVC = self.storyboard?.instantiateViewController(withIdentifier: "MobileNumberViewController") as! MobileNumberViewController
        self.navigationController?.pushViewController(mobileVC, animated: true)
    }
    
    @IBAction func btnChangeAddClk(_ sender: Any)
    {
        txtAddress.isUserInteractionEnabled = true
    }
    
    @IBAction func btnChangeNameClk(_ sender: Any)
    {
        txtServiceStationName.isUserInteractionEnabled = true
    }
    
    @IBAction func btnMobileChangeClk(_ sender: Any)
    {
        txtMobile.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        let settingImage   = UIImage(named: "setting")!
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(MyProfileSP.didTapBackButton(sender:)))
        
        let settingBtn = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(MyProfileSP.didTapSettingButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "My Profile"
        self.navigationItem.rightBarButtonItem = settingBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }

    func didTapBackButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)

    }
    func didTapSettingButton(sender: AnyObject){
        
        print("Setting btn tapped")
    }
    
}
