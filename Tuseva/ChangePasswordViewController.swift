//
//  ChangePasswordViewController.swift
//  Tuseva
//
//  Created by oms183 on 11/8/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtCurrentPass: UITextField!
    
    @IBOutlet var txtNewPass: UITextField!
    
    @IBOutlet var txtConfirmPass: UITextField!
    
    @IBOutlet var btnSave: UIButton!
    
    var actInd = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ChangePasswordViewController.didTapBackButton(sender:)))
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Change Password"
        self.navigationItem.leftBarButtonItem = backBtn
    }
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCurrentPass.resignFirstResponder()
        txtNewPass.resignFirstResponder()
        txtConfirmPass.resignFirstResponder()
        
        return true
    }

    @IBAction func btnSaveClk(_ sender: Any)
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
        if txtCurrentPass.text == "" || txtConfirmPass.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtNewPass.text == "" || checkSpace(str: txtNewPass.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Valid New Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtConfirmPass.text != txtNewPass.text
        {
            let alert = UIAlertController(title: "Tuseva", message: "Minimum Password length is 6", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtConfirmPass.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Confirm Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtConfirmPass.text != txtNewPass.text
        {
            let alert = UIAlertController(title: "Tuseva", message: "Confirm Password does not match with new password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            changePassword()
            
        }
    }
    
    func checkSpace(str:String) -> Bool
    {
        let rawString: String = str
        let whitespace = CharacterSet.whitespacesAndNewlines
        var trimmed = rawString.trimmingCharacters(in: whitespace)
        if (trimmed.characters.count ) == 0 {
            // Text was empty or only whitespace.
            return true
        }
        return false
    }
    
    func changePassword()
    {
        actInd.startAnimating()
        
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
        let strCurrentPass = txtCurrentPass.text!
        let strNewPass = txtNewPass.text!
        let strConfiPass = txtConfirmPass.text!
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=change_password&user_id=\(userID)&current_password=\(strCurrentPass)&new_password=\(strNewPass)&confirm_password=\(strConfiPass)")!
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
                            let msg1:String = resJson.value(forKey:  "RESPONSE") as! String
                            
                            message = "\(msg1)"
                            
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
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
