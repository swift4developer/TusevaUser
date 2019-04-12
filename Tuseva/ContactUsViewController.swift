//
//  ContactUsViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/4/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit
import Alamofire

class ContactUsViewController: UIViewController {

    @IBOutlet var backgroundVC: UIView!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblFeedback: UILabel!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var btnCallUs: UIButton!
    
    @IBOutlet var lblName: UITextField!
    
    @IBOutlet var lblMobile: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtSubject: UITextField!
    var strIsMsg:String = ""
    var strSpID:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    var isReveal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBar(textField: txtView)
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
//        txtView.delegate = self
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = UIColor.gray.cgColor
        txtView.layer.cornerRadius = 2
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ContactUsViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Contact Us"
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    func didTapBackButton(sender: AnyObject){
        if isReveal == "1"
        {
            let revealController: SWRevealViewController? = revealViewController()
            let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
            
            let navigationController = UINavigationController(rootViewController: dashVC)
            
            revealController?.pushFrontViewController(navigationController, animated: true)
            
        }
        else
        {

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if lblName.text == "Enter Your Name*"
        {
            lblName.text = ""
        }
        else if lblMobile.text == "Enter Your Number*"
        {
            lblMobile.text = ""
        }
        else if txtEmail.text == "Enter Your Email Address*"
        {
            txtEmail.text = ""
        }
        else if txtSubject.text == "Enter a Subject*"
        {
            txtSubject.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if lblName.text == ""
        {
            lblName.text = "Enter Your Name*"
        }
        else if lblMobile.text == ""
        {
            lblMobile.text = "Enter Your Number*"
        }
        else if txtEmail.text == ""
        {
            txtEmail.text = "Enter Your Email Address*"
        }
        else if txtSubject.text == ""
        {
            txtSubject.text = "Enter a Subject*"
        }
    }

    
    @IBAction func btnSendClk(_ sender: Any)
    {
       validation()
    }
    
    func validation()
    {
        if lblName.text! == ""  || lblName.text! == "Enter Your Name*"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Your Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lblMobile.text! == "" || lblMobile.text!.characters.count != 10 || lblMobile.text! == "Enter Your Number*"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Valid Mobile number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if txtEmail.text == "" || txtEmail.text == "Enter Your Email Address*" || !((txtEmail.text?.isEmail)!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Valid Email ID", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if txtSubject.text! == "" || txtSubject.text! == "Enter a Subject*"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Some Subject", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if txtView.text == "" || txtView.text == "Please enter some message.."
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Your Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if currentReachabilityStatus != .notReachable
            {
                loginCheck(isActive: "")
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

        }
    }
//    {
//        if txtView.text == "Please enter some message.."
//        {
//            let alert = UIAlertController(title: "Tuseva", message: "Please fill some message", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else
//        {
//            if currentReachabilityStatus != .notReachable
//            {
//                loginCheck(isActive: "")
//            }
//            else
//            {
//                print("Internet connection FAILED")
//                
//                alert()
//                
//            }
//
//        }
//    }
    
    func loginCheck(isActive:String)  {
        
        let id:String = UserDefaults.standard.value(forKey: "ID") as! String
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=logincheck&user_id=\(id)")!
        
        print("URL>\(url)")
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    
                    if responseCode == 0
                    {
                        let message = resJson.value(forKey:  "RESPONSE") as? String
                        
                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else if responseCode == 1
                    {
                        print("Success")
                        
                        //                        if isActive == "1"
                        //                        {
                        //                            self.upload()
                        //                        }
                        //                        else
                        //                        {
                        if self.strIsMsg == "1"
                        {
                            self.sendMessage()
                        }
                        else
                        {
                            self.contactUS()
                        }
                        //                        }
                        
                    }
                }
            }
            else if response.result.isFailure
            {
                
                if let error = response.result.error
                {
                    print("Response Error \(error.localizedDescription)")
                    
                }
                
            }
        }
    }

    
    func sendMessage()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
        //                let userID:String = "62"
        
        let strMsg:String? = txtView.text
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=send_message&user_id=\(userID)&sp_id=\(strSpID)&message=\(strMsg!)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        
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
    
    
    func contactUS()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//                let userID:String = "62"
        
        let strMsg:String = txtView.text!
        
        let strFirstName:String = lblName.text!
        let strMobile:String = lblMobile.text!
        let strEmail:String = txtEmail.text!
        let strSubject:String = txtSubject.text!
        
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=contact_us&user_id=\(userID)&message=\(strMsg!)".replacingOccurrences(of: " ", with: "%20")
        
        
        let newString: String = "omsoftware.us/overachievers/tuseva_service/webservices.php?action=contact_us&user_id=\(userID)&name=\(strFirstName)&mobile_no=\(strMobile)&email=\(strEmail)&subject=\(strSubject)&message=\(strMsg)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        
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
        let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    @IBAction func btnCallUs(_ sender: Any)
    {
        let mobileNo:String? = "9827934362"
        guard let number = URL(string: "telprompt://\(mobileNo!)")
            else
        {
            return
        }
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(number)
        }
        else
        {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
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

extension ContactUsViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ContactUsViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ContactUsViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtView.delegate = self
        txtView.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtView.text == "Please enter some message.."
        {
            txtView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtView.text == ""
        {
            txtView.text = "Please enter some message.."
        }
    }

}


