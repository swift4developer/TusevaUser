//
//  ForgotPasswordViewController.swift
//  Tuseva
//
//  Created by oms183 on 8/19/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet var scrollVC: UIView!
    
    @IBOutlet var viewMobile: UIView!
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtMobile: UITextField!
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDoneButtonOnKeyboard()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false

        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ForgotPasswordViewController.didTapBackButton(sender:)))
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Forgot Password"
        self.navigationItem.leftBarButtonItem = backBtn
    }
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ForgotPasswordViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtMobile.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtMobile.resignFirstResponder()
    }

    

    @IBAction func btnNextClk(_ sender: Any)
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
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = txtMobile.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        
        if txtMobile.text == "" || txtMobile.text!.characters.count > 10 || txtMobile.text != filtered || checkSpace(str: txtMobile.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            forgotPassword()
            
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

    
    func forgotPassword()
    {
        actInd.startAnimating()
        let mobNO:String = txtMobile.text!
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=forgot_password_user&mobile_no=\(mobNO)")!
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
                            let msg2:String = resJson.value(forKey: "RESPONSEPASS") as! String
                            
                            message = "\(msg1) Please save this new password - \(msg2)"
                            
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
       if currentReachabilityStatus != .notReachable
       {
            self.navigationController?.popViewController(animated: true)
        }
       else
       {
        print("Internet connection FAILED")
        
        alert()
        
        }

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
