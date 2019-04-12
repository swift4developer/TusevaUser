//
//  RegisterViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 25/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var scrollview: TPKeyboardAvoidingScrollView!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtConfirmPass: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtCity: UITextField!
    
    @IBOutlet var lblCity: UILabel!
    
    var strUserId:String = ""
    
    @IBOutlet var btnCity: UIButton!
    var tokenID:String = ""
    
    var strFirstName:String = ""
    var strLastName:String = ""
    var strEmail:String = ""
    var isFromLogin:String = ""
    var strfbid:String = ""
    var strgmailid:String = ""
    var strImage :String = ""
    
    var actInd = UIActivityIndicatorView()
    
    var TableView = UITableView()
    
    var arrSelectCity = [responseArraySelectCity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDoneButtonOnKeyboard()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegisterViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtFirstName.inputAccessoryView = doneToolbar
        self.txtLastName.inputAccessoryView = doneToolbar
        self.txtPhoneNumber.inputAccessoryView = doneToolbar
        self.txtEmail.inputAccessoryView = doneToolbar
        self.txtCity.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtCity.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtCity.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPass.delegate = self
        txtPhoneNumber.delegate = self
        
        let txtFirstPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtFirstName.frame.height))
        txtFirstName.leftView = txtFirstPadding
        txtFirstName.leftViewMode = UITextFieldViewMode.always
        
        let txtMobilePadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtPhoneNumber.frame.height))
        txtPhoneNumber.leftView = txtMobilePadding
        txtPhoneNumber.leftViewMode = UITextFieldViewMode.always
        
        let txtLastPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtLastName.frame.height))
        txtLastName.leftView = txtLastPadding
        txtLastName.leftViewMode = UITextFieldViewMode.always
        
        let txtEmailPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtEmail.frame.height))
        txtEmail.leftView = txtEmailPadding
        txtEmail.leftViewMode = UITextFieldViewMode.always
        
        let txtCityPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtCity.frame.height))
        txtCity.leftView = txtCityPadding
        txtCity.leftViewMode = UITextFieldViewMode.always
        
        let txtPasswordPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtPassword.frame.height))
        txtPassword.leftView = txtPasswordPadding
        txtPassword.leftViewMode = UITextFieldViewMode.always
        
        let txtConPassPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtConfirmPass.frame.height))
        txtConfirmPass.leftView = txtConPassPadding
        txtConfirmPass.leftViewMode = UITextFieldViewMode.always
        
        detailsView.layer.cornerRadius = 3.0
        
        self.btnRegister.layer.cornerRadius = self.btnRegister.frame.height/2.0;
        
        hideKeyboardWhenTappedAround()
        
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(RegisterViewController.didTapBackButton(sender:)))
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Registration"
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        TableView.isHidden = true
        
        TableView.delegate = self
        TableView.dataSource = self
        
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        TableView.frame = CGRect(x: self.lblCity.frame.origin.x , y:  self.lblCity.frame.origin.y + self.lblCity.frame.size.height, width: self.lblCity.frame.size.width, height: 120)
        TableView.estimatedRowHeight = 60
        self.detailsView.addSubview(TableView)

        
        if isFromLogin == "0" || isFromLogin == "2"
        {
            txtFirstName.text = strFirstName
            txtLastName.text = strLastName
            txtEmail.text = strEmail
        }
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBAction func btnCityClk(_ sender: Any)
    {
        if (TableView.isHidden == true ) {
            TableView.isHidden = false
            
            selectCity()
//            fuelTableView.frame = CGRect(x: self.repairView.frame.origin.x , y:  self.repairView.frame.origin.y + self.repairView.frame.size.height, width: self.repairView.frame.size.width, height: 180)
//            fuelTableView.estimatedRowHeight = 60
//            self.view.addSubview(fuelTableView)
        }
        else
        {
            TableView.isHidden = true
        }
    }
    
    func selectCity()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_city".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrSelectCity.removeAll()
                    
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
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
                            {
                                for arrData in resValue {
                                    
                                    guard let name = arrData["city_name"] as? String else {
                                        return
                                    }
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArraySelectCity(cityName: name, cityID: id!)
                                    
                                    self.arrSelectCity.append(r)
                                }
                                DispatchQueue.main.async(execute: {
                                    self.TableView.reloadData()
                                    self.actInd.stopAnimating()
                                })
                            }
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

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSelectCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = arrSelectCity[indexPath.row].cityName
    
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)
        
        txtCity.text = arrSelectCity[indexPath.row].cityName
        
//        cityID = arrSelectCity[indexPath.row].cityID!
//        
//        CheckCity(city: txtSearch.text!)
        
        TableView.isHidden = true
        
    }
//    class responseArraySelectCity
//    {
//        var cityName:String?
//        var cityID:String?
//        
//        init(cityName:String, cityID:String)
//        {
//            self.cityName = cityName
//            self.cityID = cityID
//        }
//        
//        
//    }
//
    
    @IBAction func btnRegisterClk(_ sender: Any)
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
        let testStr = txtEmail.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isValid:Bool = emailTest.evaluate(with: testStr)
        
        
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = txtPhoneNumber.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        
        if txtFirstName.text == "" || txtFirstName.text == "First Name*" || checkSpace(str: txtFirstName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter FirstName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtLastName.text == "" || txtLastName.text == "Last Name*" || checkSpace(str: txtLastName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter LastName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtPhoneNumber.text == "" || txtPhoneNumber.text!.characters.count > 10 || txtPhoneNumber.text != filtered || txtPhoneNumber.text == "Phone No*" || checkSpace(str: txtPhoneNumber.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !isValid
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Email Id", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtCity.text == "City*" || txtCity.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Select City", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtPassword.text == "Password*" || txtPassword.text == "" || checkSpace(str: txtPassword.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtPassword.text!.characters.count < 6
        {
            let alert = UIAlertController(title: "Tuseva", message: "Minimum Password length is 6", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtConfirmPass.text != txtPassword.text
        {
            let alert = UIAlertController(title: "Tuseva", message: "Password does not match the confirm password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            register()
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
    
    func register()
    {
        actInd.startAnimating()
        let firstName: String = txtFirstName.text!
        let lastName: String = txtLastName.text!
        let mobileNO: String = txtPhoneNumber.text!
        let emailId: String = txtEmail.text!
        let city:String = txtCity.text!
        let password:String = txtPassword.text!
        let ConPassword:String = txtConfirmPass.text!
        
        tokenID = (UIDevice.current.identifierForVendor?.uuidString)!
        UserDefaults.standard.set(tokenID, forKey: "device_id")
        
        var newString: String = ""
        if isFromLogin == "0"
        {
            newString = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=signup_user&first_name=\(firstName)&last_name=\(lastName)&mobile_no=\(mobileNO)&email_id=\(emailId)&city=\(city)&password=\(password)&cpassword=\(ConPassword)&fbid=\(strfbid)&image=\(strImage)".replacingOccurrences(of: " ", with: "%20")
        }
        if isFromLogin == "2"
        {
            newString = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=signup_user&first_name=\(firstName)&last_name=\(lastName)&mobile_no=\(mobileNO)&email_id=\(emailId)&city=\(city)&password=\(password)&cpassword=\(ConPassword)&gmailid=\(strgmailid)&image=\(strImage)".replacingOccurrences(of: " ", with: "%20")
        }

        else
        {
            newString = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=signup_user&first_name=\(firstName)&last_name=\(lastName)&mobile_no=\(mobileNO)&email_id=\(emailId)&city=\(city)&password=\(password)&cpassword=\(ConPassword)".replacingOccurrences(of: " ", with: "%20")
        }
        
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
                            message = "\(resJson.value(forKey:  "RESPONSE")!)"
                            
                            let userdefaults = UserDefaults.standard
                            
                            let userid:Int = resJson.value(forKey:  "RESPONSEid") as! Int
                            
                            self.strUserId = "\(userid)"
                            
                            userdefaults.set(self.strUserId, forKey: "ID")
//                            userdefaults.set(resJson.value(forKey:"password"), forKey: "password")
                            userdefaults.set(resJson.value(forKey:"otp"), forKey: "otp")
                            
                            userdefaults.set(self.txtPhoneNumber.text, forKey: "mobile")
                            
                            userdefaults.set(self.txtCity.text, forKey: "city")
                            
                            print(resJson.value(forKey:"RESPONSEid") ?? 0)
//                            print(resJson.value(forKey:"password") ?? 0)
                            print(resJson.value(forKey:"otp") ?? 0)
                            
                            
                            
                            self.actInd.startAnimating()
                            User.registerUser(withName: self.txtFirstName.text!, email: self.txtEmail.text!, password: self.txtPassword.text!) { [weak weakSelf = self] (status) in
                                DispatchQueue.main.async {
                                    weakSelf?.self.actInd.stopAnimating()
                                    if status == true {
                                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                            
//                                            if User?.uid != nil {
                                            // store User in FIREBASE DATABASE
                                            DBProvider.Instance.saveUser(withID: self.strUserId, device_token: self.tokenID, email: self.txtEmail.text!, user_id: self.strUserId, status: false, typing: false)
//                                            }
                                            self.gotoNextVC()
                                            
                                            self.actInd.stopAnimating()
                                            
                                        }))
                                        self.present(alert, animated: true, completion: nil)

                                    } else {
                                        
                                        print(Error.self)
                                    }
                                }
                            }

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
        let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyViewController") as! OTPVerifyViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    else
    {
        print("Internet connection FAILED")
        
        alert()
        
    }

}

}
