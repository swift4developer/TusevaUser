//
//  OTPVerifyViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 25/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import PinCodeTextField
import Alamofire

class OTPVerifyViewController: UIViewController, PinCodeTextFieldDelegate {

    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var txtCode: PinCodeTextField!
    
    @IBOutlet var btnVerify: UIButton!
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCode.delegate = self
        txtCode.keyboardType = .numberPad

        txtMobileNumber.isUserInteractionEnabled = false
        txtMobileNumber.text = UserDefaults.standard.value(forKey: "mobile") as? String
        
        self.btnVerify.layer.cornerRadius = self.btnVerify.frame.height/2.0;
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        if currentReachabilityStatus != .notReachable
        {
            setOtp()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
        self.addDoneButtonOnKeyboard()
    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(OTPVerifyViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtMobileNumber.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.txtCode.resignFirstResponder()
        self.txtMobileNumber.resignFirstResponder()
        
    }

    
    func setOtp()
    {
        actInd.startAnimating()
        let mobNO:String = txtMobileNumber.text!
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=set_otp_user&mobile_no=\(mobNO)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
//        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=set_otp_user&mobile_no=\(mobNO)")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
                        var message : String?
                        if responseCode == 0
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            message = "OTP send to your registered mobile number"
                            
                            self.txtCode.text = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
            else if response.result.isFailure
            {
                print("Response Error")
                self.actInd.stopAnimating()
            }
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        print("value changed: \(String(describing: txtCode.text))")
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func btnVerifyClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            validationOtp()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
    }
    
    func validationOtp()
    {
        if txtMobileNumber.text == "" || txtMobileNumber.text!.characters.count > 10
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtCode.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Otp", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            confirmOtp()
        }

    }
    
    func confirmOtp()
    {
        actInd.startAnimating()
        let mobNO:String = txtMobileNumber.text!
        let otp:String = txtCode.text!
        
        let tokenID = UIDevice.current.identifierForVendor?.uuidString
        UserDefaults.standard.set(tokenID!, forKey: "device_id")
        
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=confirm_otp_user&mobile_no=\(mobNO)&otp=\(otp)&token_id=\(tokenID!)&device_type=ios".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
//        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=confirm_otp_user&mobile_no=\(mobNO)&otp=\(otp)&token_id=\(tokenID!)&device_type=ios")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
                        var message : String?
                        if responseCode == 0
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.gotoNextVC()
                                self.actInd.stopAnimating()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
            else if response.result.isFailure
            {
                print("Response Error")
                self.actInd.stopAnimating()
            }
        }
    }

    func gotoNextVC()
    {
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
//        self.navigationController?.pushViewController(secondViewController!, animated: true)

        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }

    
    @IBAction func btnResendClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            validation()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
    }
    
    func validation()
    {
        if txtMobileNumber.text == "" || txtMobileNumber.text!.characters.count > 10
        {
        let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else
        {
            resendOtp()
        
        }

    }
    
    func resendOtp()
    {
        actInd.startAnimating()
        let mobNO:String = txtMobileNumber.text!
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=resend_otp_user&mobile_no=\(mobNO)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
//        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=resend_otp_user&mobile_no=\(mobNO)")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
                        var message : String?
                        if responseCode == 0
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            self.txtCode.text = resJson.value(forKey:  "otp") as? String
                            
                            message = "OTP send to your registered mobile number"

                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
            else if response.result.isFailure
            {
                print("Response Error")
                self.actInd.stopAnimating()
            }
        }
    }

    
    
    @IBAction func txtEditNumberClk(_ sender: Any)
    {
        txtMobileNumber.isUserInteractionEnabled = true
    }

}
