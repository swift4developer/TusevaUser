//
//  PopUpVerifyVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 29/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import PinCodeTextField
import Alamofire

class PopUpVerifyVC: UIViewController {

    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var txtOtpCode: PinCodeTextField!
    
    var strGetOtp = ""
    var strGetQuery = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    func handleTap() {
        self.view.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        txtOtpCode.text = strGetOtp
        
        let strMobile = UserDefaults.standard.value(forKey: "mobile") as? String
        lblMobile.text = "We sent a code to \(strMobile!) Enter it to verify your number"
    }
    
    @IBAction func btnResendClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            resendQueryOtp()
        }
        else
        {
            alert()
        }
        
    }
    
    func resendQueryOtp()
    {
        actInd.startAnimating()
        let mobNO:String = UserDefaults.standard.value(forKey: "mobile") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=resend_otp_query&query_id=\(strGetQuery)&mobile_no=\(mobNO)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
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
                            
//                            self.txtOtpCode.text = resJson.value(forKey:  "otp") as? String
                            
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
    
    
    @IBAction func btnCancelClk(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func btnVerifyClk(_ sender: Any)
    {
        Validation()
    }
    
    func Validation()
    {
        if txtOtpCode.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Otp", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if currentReachabilityStatus != .notReachable
            {
                confirmOtpQuery()
            }
            else
            {
                alert()
            }
        }
    }

    func confirmOtpQuery()
    {
        actInd.startAnimating()
        let otp:String = txtOtpCode.text!
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=confirm_otp_query&query_id=\(strGetQuery)&otp=\(otp)")!
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
        let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "contact") as? PopUpShareContact
        
        var frame: CGRect = popAdVC!.view.frame;
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        popAdVC?.view.frame = frame;
        
        
        self.addChildViewController(popAdVC!)
        self.view.addSubview((popAdVC?.view)!)
        popAdVC?.didMove(toParentViewController: self)
        
    }

}
