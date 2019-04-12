//
//  CongratsPopUpVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 03/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class CongratsPopUpVC: UIViewController {
    
    
    @IBOutlet var lblText: UILabel!
    
    var strWheeler:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        strWheeler = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        
        if strWheeler == "3"
        {
            lblText.text = "Your contact details will be shared with Car Seller for better communication"
        }
        else
        {
            lblText.text = "Your contact details will be shared with Car Seller for better communication"
        }
        
        btnOk.layer.cornerRadius = btnOk.frame.size.height / 2
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap() {
        self.view.removeFromSuperview()
    }


    @IBAction func btnOKClk(_ sender: Any)
    {
//        let previousVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as! PreviousQueryVC
//        
//        
//        self.navigationController?.pushViewController(previousVC, animated: true)
        
        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(dashVC, animated: true)
    }
 
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var btnSuccess: UIButton!
    
    }
