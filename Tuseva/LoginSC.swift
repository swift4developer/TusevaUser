

//
//  LoginSC.swift
//  Tuseva
//
//  Created by Praveen Khare on 04/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class LoginSP: UIViewController {

    @IBAction func btnForgotPassClk(_ sender: Any) {
    }
    @IBOutlet var view1: UIView!
    @IBAction func btnLoginClk(_ sender: Any) {
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtServiceName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.layer.cornerRadius = 3.0
        txtUserName.layer.cornerRadius = 3.0
        txtServiceName.layer.cornerRadius = 3.0
        
        self.btnLogin.layer.cornerRadius = self.btnLogin.frame.height/2.0;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }

}
