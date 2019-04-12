

//
//  LoginSC.swift
//  Tuseva
//
//  Created by Praveen Khare on 04/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class LoginSP: UIViewController {

    @IBAction func btnForgotPassClk(_ sender: Any)
    {
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassSPViewController") as! ForgotPassSPViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnLoginClk(_ sender: Any)
    {
        validation()
        
    }
    
    func validation()
    {
        if txtServiceName.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Service Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtUserName.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter User Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtPassword.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
            self.navigationController?.pushViewController(vehicleVC, animated: true)
        }
    }
    
    @IBOutlet var view1: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtServiceName: UITextField!
    @IBOutlet var lblRegistration: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.layer.cornerRadius = 3.0
        txtUserName.layer.cornerRadius = 3.0
        txtServiceName.layer.cornerRadius = 3.0
        
        self.btnLogin.layer.cornerRadius = self.btnLogin.frame.height/2.0;
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        lblRegistration.addGestureRecognizer(tap)
        lblRegistration.isUserInteractionEnabled = true
    }
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }

}

