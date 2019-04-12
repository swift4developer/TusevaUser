//
//  ForgotPassSPViewController.swift
//  Tuseva
//
//  Created by oms183 on 8/12/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class ForgotPassSPViewController: UIViewController {

    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var btnNext: UIButton!
    
    
    @IBAction func btnNextClk(_ sender: Any)
    {
        print("NEXT CLICKED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnNext.layer.cornerRadius = self.btnNext.frame.height/2.0;
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ForgotPassSPViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Forgot Password"
        self.navigationItem.leftBarButtonItem = backBtn
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func didTapBackButton(sender: AnyObject)
    {
        
       self.navigationController?.popViewController(animated: true)
        
    }
    func didTapSettingButton(sender: AnyObject)
    {
        
        print("Setting btn tapped")
    }

}
