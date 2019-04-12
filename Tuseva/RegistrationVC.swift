//
//  RegistrationVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 04/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobNo: UITextField!
    @IBOutlet var txtServiceStation: UITextField!

    
    
    @IBAction func btnUploadImageClk(_ sender: Any) {
    }
    
    @IBAction func btnContinueClk(_ sender: Any)
    {
        validation()
    }
    
    func validation()
    {
        if txtServiceStation.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Service Station Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtMobNo.text == "" || txtMobNo.text!.characters.count > 10
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Valid Mobile number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtAddress.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
            self.navigationController?.pushViewController(vehicleVC, animated: true)
        }
    }

    
    @IBAction func btnAlreadyRegister(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }

}
