


//
//  RegistrationCDViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 09/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class RegistrationCDViewController: UIViewController {

    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btn2Wheeler: UIButton!
    @IBOutlet var btn4Wheeler: UIButton!
    @IBOutlet var txtBrand: UITextField!
    @IBOutlet var btnPlaceRequest: UIButton!
    
    @IBAction func btnBrandClk(_ sender: Any) {
    }
    
    @IBAction func btn2WheelerClk(_ sender: Any) {
    }
    
    @IBAction func btn4WheelerClk(_ sender: Any) {
    }
 
    @IBAction func btnPlaceReqClk(_ sender: Any)
    {
        validation()
    }
    
    func validation()
    {
        if txtCompanyName.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Company Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtAddress.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtMobileNo.text == "" || txtMobileNo.text!.characters.count > 10
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtEmail.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid EmailId", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            //            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }

    
    @IBAction func btnAlreadyRegClk(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        btnPlaceRequest.layer.cornerRadius = btnPlaceRequest.frame.size.height / 2
    }

}
