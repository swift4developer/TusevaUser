//
//  JoinUSViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 04/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class JoinUSViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var txtViewDescription: UITextView!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var lbltxtMobileNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    
    @IBOutlet var btnServiceProvider: UIButton!
    @IBOutlet var btnCarDealer: UIButton!
    
    @IBOutlet var btnSparePart: UIButton!
    

    var isServiceProvider:String = "service_station"
    var desc:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    var isReveal:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnServiceProvider.layer.cornerRadius = self.btnServiceProvider.frame.size.height / 2
        btnCarDealer.layer.cornerRadius = self.btnCarDealer.frame.size.height / 2
        
        btnCarDealer.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnCarDealer.layer.borderWidth = 2
        
        txtViewDescription.layer.borderColor = UIColor.gray.cgColor
        txtViewDescription.layer.borderWidth = 1
        txtViewDescription.layer.cornerRadius = 2
        txtViewDescription.delegate = self
        txtViewDescription.text = "Please enter description.."
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(JoinUSViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Join Us"
        self.navigationItem.leftBarButtonItem = backBtn
        
        hideKeyboardWhenTappedAround()

        self.addDoneButtonOnKeyboard()
    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(JoinUSViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtFirstName.inputAccessoryView = doneToolbar
        self.txtLastName.inputAccessoryView = doneToolbar
        self.lbltxtMobileNumber.inputAccessoryView = doneToolbar
        self.txtCity.inputAccessoryView = doneToolbar
        self.txtAddress.inputAccessoryView = doneToolbar
        self.txtEmail.inputAccessoryView = doneToolbar
        self.txtViewDescription.inputAccessoryView = doneToolbar


    }
    
    func doneButtonAction()
    {
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.lbltxtMobileNumber.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtCity.resignFirstResponder()
        self.txtAddress.resignFirstResponder()
        self.txtViewDescription.resignFirstResponder()

    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewDescription.text == "Please enter description.."
        {
            txtViewDescription.text = ""
        }
        else
        {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtViewDescription.text == ""
        {
            txtViewDescription.text = "Please enter description.."
        }
        else
        {
            
        }
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
                            self.joinUS()
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


    @IBAction func btnServiceProClk(_ sender: Any)
    {
        isServiceProvider = "service_station"
        
        btnCarDealer.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnCarDealer.layer.borderWidth = 2
        btnCarDealer.layer.backgroundColor = UIColor.white.cgColor
        btnCarDealer.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnSparePart.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnSparePart.layer.borderWidth = 2
        btnSparePart.layer.backgroundColor = UIColor.white.cgColor
        btnSparePart.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnServiceProvider.layer.backgroundColor = UIColor(red:0/255, green:92/255, blue:172/255, alpha:1.0).cgColor
        btnServiceProvider.layer.borderWidth = 0
        btnServiceProvider.setTitleColor(UIColor.white, for: .normal)

    }
    
    @IBAction func btnCarDealerClk(_ sender: Any)
    {
        isServiceProvider = "car_dealer"
        
        
        btnServiceProvider.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnServiceProvider.layer.borderWidth = 2
        btnServiceProvider.layer.backgroundColor = UIColor.white.cgColor
        
        btnServiceProvider.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnSparePart.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnSparePart.layer.borderWidth = 2
        btnSparePart.layer.backgroundColor = UIColor.white.cgColor
        btnSparePart.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnCarDealer.layer.backgroundColor = UIColor(red:0/255, green:92/255, blue:172/255, alpha:1.0).cgColor
        btnCarDealer.layer.borderWidth = 0
        btnCarDealer.setTitleColor(UIColor.white, for: .normal)

    }
    
    
    @IBAction func btnSparePartClk(_ sender: Any) {
        
        isServiceProvider = "spare_part"
        
        
        btnServiceProvider.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnServiceProvider.layer.borderWidth = 2
        btnServiceProvider.layer.backgroundColor = UIColor.white.cgColor
        
        btnServiceProvider.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnCarDealer.layer.borderColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0).cgColor
        btnCarDealer.layer.borderWidth = 2
        btnCarDealer.layer.backgroundColor = UIColor.white.cgColor
        btnCarDealer.setTitleColor(UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0), for: .normal)
        
        btnSparePart.layer.backgroundColor = UIColor(red:0/255, green:92/255, blue:172/255, alpha:1.0).cgColor
        btnSparePart.layer.borderWidth = 0
        btnSparePart.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    
    @IBAction func btnSubmit(_ sender: Any)
    {
        validation()
    }
    
    func validation()
    {
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = lbltxtMobileNumber.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        
        
        let testStr = txtEmail.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isValid:Bool = emailTest.evaluate(with: testStr)

        
        if txtFirstName.text == "First Name *" || txtFirstName.text == "" || checkSpace(str: txtFirstName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter FirstName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtLastName.text == "Last Name*" || txtLastName.text == "" || checkSpace(str: txtLastName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter LastName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtEmail.text == "Email Id*" || txtEmail.text == "" || checkSpace(str: txtEmail.text!) || !isValid
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Email Id", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lbltxtMobileNumber.text == "" || lbltxtMobileNumber.text!.characters.count > 10 || lbltxtMobileNumber.text != filtered || checkSpace(str: lbltxtMobileNumber.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtCity.text == "City*"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter City", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtAddress.text == "Address*"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtViewDescription.text == "Please enter description.."
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Description", preferredStyle: .alert)
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
                alert()
            }
            
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

    
    func joinUS()
    {
        let firstName: String = txtFirstName.text!
        let lastName: String = txtLastName.text!
        let mobileNO: String = lbltxtMobileNumber.text!
        let emailId: String = txtEmail.text!
        let city:String = txtCity.text!
        let address:String = txtAddress.text!

        if txtViewDescription.text == "Please enter description.."
        {
            desc = ""

        }
        else
        {
            desc = txtViewDescription.text!

        }
        
        actInd.startAnimating()
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=join_us&first_name=\(firstName)&last_name=\(lastName)&join_type=\(isServiceProvider)&mobile_no=\(mobileNO)&email_id=\(emailId)&address=\(address)&city=\(city)&description=\(desc)".replacingOccurrences(of: " ", with: "%20")
        
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
            }
        }
    }
    
    func gotoNextVC()
    {
        if currentReachabilityStatus != .notReachable
        {
            let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
            self.navigationController?.pushViewController(verifyVC, animated: true)
            
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
    }
}
