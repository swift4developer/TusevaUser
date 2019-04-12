//
//  MyProfileViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 29/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var btnUpdate: UIButton!
    
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnDeleteAccountClk: UIButton!
    @IBOutlet var logoutView: UIView!
    @IBOutlet var imgUserIcon: UIImageView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var switchShare: UISwitch!
    
    @IBOutlet var btnChangePass: UIButton!
    var valueSwitch:String = ""
    
    var btnClk:String = ""
    
    var strIsImgPicked:String = ""
    
    var ProfileImage:UIImage?
    
    let picker = UIImagePickerController()
    
    var actInd = UIActivityIndicatorView()
    
    var isActive:String = ""
    
    var isReveal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
       
         picker.delegate = self
        
        self.addDoneButtonOnKeyboard()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        if currentReachabilityStatus != .notReachable
        {
            isActive = ""
            loginCheck()
//            getProfile()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MyProfileViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtFirstName.inputAccessoryView = doneToolbar
        self.txtLastName.inputAccessoryView = doneToolbar
        self.txtPhoneNo.inputAccessoryView = doneToolbar
        self.txtEmail.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtPhoneNo.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        logoutView.isHidden = true
        switchShare.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        self.imgUserIcon.layer.cornerRadius = self.imgUserIcon.frame.size.height / 2
        self.imgUserIcon.clipsToBounds = true
        
//        if UserDefaults.standard.value(forKey: "switch") != nil
//        {
//            if UserDefaults.standard.value(forKey: "switch")as! String == "1"
//            {
//                self.switchShare.setOn(true, animated: true)
//            }
//            else
//            {
//                self.switchShare.setOn(false, animated: true)
//            }
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loginCheck()  {
        
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
                        
                        if self.isActive == "1"
                        {
                            self.updateProfile()
                        }
                        else if self.isActive == "2"
                        {
                            self.deleteAccount()
                        }
                        else if self.isActive == "3"
                        {
                            self.myImageUploadRequest()
                        }
                        else
                        {
                            self.getProfile()
                        }
                        
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

    
    func getProfile()
    {
        self.actInd.startAnimating()
            let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userID:String = "5"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=profile_user&id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
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
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                self.actInd.stopAnimating()

                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        let userdefaults = UserDefaults.standard
                                        
                                        userdefaults.set(dict.value(forKey:"first_name"), forKey: "first_name")
                                        userdefaults.set(dict.value(forKey:"last_name"), forKey: "last_name")
                                        
                                        userdefaults.set(dict.value(forKey:"mobile_no"), forKey: "mobile")
                                        
                                        userdefaults.set(dict.value(forKey:"email"), forKey: "email")
                                        
                                     
                                        userdefaults.set(dict.value(forKey:"image"), forKey: "image")
                                        
                                        
                                        self.txtFirstName.text = dict.value(forKey:"first_name") as? String
                                        self.txtLastName.text = dict.value(forKey:"last_name") as? String
                                        self.txtPhoneNo.text = dict.value(forKey:"mobile_no") as? String
                                        self.txtEmail.text = dict.value(forKey:"email") as? String
                                        
                                        let imgURL = dict.value(forKey:"image")
                                        self.imgUserIcon.setImageFromURl(stringImageUrl: imgURL as! String)
                                        //                                        self.imgUserIcon.layer.cornerRadius = self.imgUserIcon.frame.size.height / 2
                                        //                                        self.imgUserIcon.clipsToBounds = true
                                        
                                        guard let doNotShare = dict.value(forKey: "doNotShare") as? String
                                            else
                                        {
                                            return
                                        }
                                        
                                         userdefaults.set(doNotShare, forKey: "doNotShare")
                                        
                                        
                                        self.valueSwitch = doNotShare
                                        if self.valueSwitch == "1"
                                        {
                                            self.switchShare.setOn(true, animated: true)
                                        }
                                        else
                                        {
                                            self.switchShare.setOn(false, animated: true)
                                        }

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
    
    
    @IBAction func btnBackClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if isReveal == "1"
            {
                let revealController: SWRevealViewController? = revealViewController()
                let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
                
                let navigationController = UINavigationController(rootViewController: dashVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)

            }
            else
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                self.navigationController?.pushViewController(secondViewController!, animated: true)
//                let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
//               
//                self.navigationController?.pushViewController(verifyVC, animated: true)
            }
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
    }
    
    @IBAction func btnSettingClk(_ sender: Any)
    {
        self.logoutView.isHidden = false
    }
    
    
    @IBAction func btnLogoutClk(_ sender: Any)
    {
        self.logoutView.isHidden = true
        
//        UserDefaults.standard.removeObject(forKey: "ID")
        
        
        User.logOutUser { (status) in
            if status == true {
                
                let domain = Bundle.main.bundleIdentifier!
                
                UserDefaults.standard.removePersistentDomain(forName: domain)
                
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true, completion: nil)

                let serviceHistVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navVC = UINavigationController(rootViewController: serviceHistVC)
                self.present(navVC, animated: true, completion: nil)
            }
        }        
    }
    
    @IBAction func btnChangePassClk(_ sender: Any)
    {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    @IBAction func switchShareClk(_ sender: Any)
    {
        if switchShare.isOn
        {
            self.valueSwitch = "1"
        }
        else
        {
            self.valueSwitch = "0"
        }
        
        UserDefaults.standard.set(valueSwitch, forKey: "switch")
    }
    
    
    func validation()
    {
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = txtPhoneNo.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        
        if txtFirstName.text == "" || checkSpace(str: txtFirstName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter FirstName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtLastName.text == "" || checkSpace(str: txtLastName.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter LastName", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtPhoneNo.text == "" || txtPhoneNo.text!.characters.count > 10 || txtPhoneNo.text != filtered || checkSpace(str: txtPhoneNo.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter valid Mobile No", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            isActive = "1"
            loginCheck()
//            updateProfile()
            
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

    
    func updateProfile ()
    {
        actInd.startAnimating()
        
        let firstName: String = txtFirstName.text!
        let lastName: String = txtLastName.text!
        let mobileNO: String = txtPhoneNo.text!
        let emailId: String = txtEmail.text!
        let userID: String = UserDefaults.standard.value(forKey: "ID") as! String
        
        //        let userID:String = "5"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=update_profile_user&id=\(userID)&first_name=\(firstName)&last_name=\(lastName)&mobile_no=\(mobileNO)&email_id=\(emailId)&doNotShare=\(valueSwitch)".replacingOccurrences(of: " ", with: "%20")
        
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
                            
                            
                            let userdefaults = UserDefaults.standard
                            
                            userdefaults.set(self.txtFirstName.text, forKey: "first_name")
                            userdefaults.set(self.txtLastName.text, forKey: "last_name")
                            
                            userdefaults.set(self.txtPhoneNo.text, forKey: "mobile")
                            
                            userdefaults.set(self.txtEmail.text, forKey: "email")
                            userdefaults.set(self.valueSwitch, forKey: "doNotShare")
                            
//                            userdefaults.set(dict.value(forKey:"image"), forKey: "image")
//                            
                            
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                
                                self.actInd.stopAnimating()
//                                self.gotoNextVC()
                                
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
        if btnClk == "service"
        {
            
            let serviceHistVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceHistoryVC") as! ServiceHistoryVC
            let navVC = UINavigationController(rootViewController: serviceHistVC)
            self.present(navVC, animated: true, completion: nil)
        }
        else
        {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ManageVehicleVC") as! ManageVehicleVC
            let navController = UINavigationController(rootViewController: VC1)
            self.present(navController, animated:true, completion: nil)
            
        }
    }
    
    @IBAction func btnUpdateClk(_ sender: Any)
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
    
    
    @IBAction func btnServiceHistoryClk(_ sender: Any)
    {
        btnClk = "service"
        
        let serviceHistVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceHistoryVC") as! ServiceHistoryVC
        let navVC = UINavigationController(rootViewController: serviceHistVC)
        self.present(navVC, animated: true, completion: nil)

        
//        if currentReachabilityStatus != .notReachable
//        {
//            validation()
//        }
//        else
//        {
//            print("Internet connection FAILED")
//            
//            alert()
//            
//        }

    }
    
    @IBAction func btnManageVehicleClk(_ sender: Any)
    {
        btnClk = "vehicle"
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ManageVehicleVC") as! ManageVehicleVC
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
        
//        if currentReachabilityStatus != .notReachable
//        {
//            validation()
//        }
//        else
//        {
//            print("Internet connection FAILED")
//            
//            alert()
//            
//        }

    }

    @IBAction func btnAddPhotoClk(_ sender: Any)
    {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Gallary", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            self.picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            
        })
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            } else {
                self.noCamera()
            }
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }

    func noCamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        
        alertVC.addAction(okAction)
        
        present(alertVC,animated: true,completion: nil)
    }
    
    //MARK: - Delegates
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//        var  chosenImage = UIImage()
//        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//     
//        imgUserIcon.image = chosenImage //4
//        ProfileImage = chosenImage
//        dismiss(animated:true, completion: nil) //5
//        
//        myImageUploadRequest()
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgUserIcon.image = image
        }
        else
        {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.isActive = "3"
        self.loginCheck()
//        myImageUploadRequest()

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func myImageUploadRequest()
    {
        actInd.startAnimating()
        
        let myUrl = NSURL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=upload_profile_image");
        
        let id:String = (UserDefaults.standard.value(forKey: "ID")! as? String)!
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "id"  : "\(id)"
        ]
        
        print(param)
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(imgUserIcon.image!, 1)
        
        if(imageData==nil)  { return; }
        
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            print("REQ BODY>>\(request.url!)")
            
            if error != nil {
                print("error=\(error!)")
                self.actInd.stopAnimating()
                return
            }
            
            // You can print out response object
            print("******* response = \(response!)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json!)
                
                let resCode = json?.value(forKey: "RESPONSECODE") as? Int
                
                let msg = json?.value(forKey: "RESPONSE") as? String
                
                if resCode == 1
                {
                    let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
                    
                    alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        self.actInd.stopAnimating()
                    }))
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                else
                {
                    let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
                    
                    alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        self.actInd.stopAnimating()
                    }))
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                DispatchQueue.main.async(execute: {
                    self.actInd.stopAnimating()
                    self.imgUserIcon.setImageFromURl(stringImageUrl: "\(json?.value(forKey: "RESPONSEIMG") as? String ?? "image")");
                });
                
            }catch
            {
                print(error)
                
            }
            
        }
        task.resume()
    }

    
    
//    func myImageUploadRequest()
//    {
//        actInd.startAnimating()
//        let myUrl = NSURL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=upload_profile_image");
//        
//        let id:String = (UserDefaults.standard.value(forKey: "ID")! as? String)!
//        
//        let request = NSMutableURLRequest(url:myUrl! as URL);
//        request.httpMethod = "POST";
//        
//        let param = [
//            "id"  : "\(id)"
//        ]
//        
//        print(param)
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        
//        let imageData = UIImageJPEGRepresentation(imgUserIcon.image!, 1)
//        
//        if(imageData==nil)  { return; }
//        
//        
//        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
//        
//        
//        
//        //        myActivityIndicator.startAnimating();
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//            
//            print("REQ BODY>>\(request.url!)")
//            
//            if error != nil {
//                print("error=\(error!)")
//                return
//            }
//            
//            // You can print out response object
//            print("******* response = \(response!)")
//            
//            // Print out response body
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("****** response data = \(responseString!)")
//            
//            self.actInd.stopAnimating()
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
//                
//                print(json!)
//                
//                let resCode = json?.value(forKey: "RESPONSECODE") as? Int
//                
//                let msg = json?.value(forKey: "RESPONSE") as? String
//                
//                if resCode == 1
//                {
//                    let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
//                    
//                    alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                        self.actInd.stopAnimating()
//                    }))
//                    
//                    self.present(alertVC, animated: true, completion: nil)
//                }
//                else
//                {
//                    let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
//                    
//                    alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                        self.actInd.stopAnimating()
//                    }))
//                    
//                    self.present(alertVC, animated: true, completion: nil)
//                }
//
//                DispatchQueue.main.async(execute: {
//                    //                    self.myActivityIndicator.stopAnimating()
//                    self.imgUserIcon.setImageFromURl(stringImageUrl: "\(json?.value(forKey: "RESPONSEIMG") as? String ?? "userImage")");
//                });
//                
//            }catch
//            {
//                print(error)
//                self.actInd.stopAnimating()
//            }
//            
//        }
//        
//        print("TASK>>\(task)")
//        
//        task.resume()
//    }
    
    
//    func myImageUploadRequest()
//    {
//        actInd.startAnimating()
//        let userID = UserDefaults.standard.value(forKey: "ID") as! String
//        var parameters = [String:String]()
//        
//        parameters = ["id":"\(userID)"
//        ]
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(UIImageJPEGRepresentation(self.imgUserIcon.image!, 0.5)!, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//            
//        }, to:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=upload_profile_image")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                })
//                
//                upload.responseJSON { response in
//                    //self.delegate?.showSuccessAlert()
//                    print(response.request!)  // original URL request
//                    print(response.response!) // URL response
//                    print(response.data!)     // server data
//                    print(response.result)   // result of response serialization
//                    //                        self.showSuccesAlert()
//                    //                    //self.removeImage("frame", fileExtension: "txt")
//                    //                    if let JSON = response.result.value {
//                    //                        print("JSON: \(JSON)")
//                    //
//                    //                        self.actInd.stopAnimating()
//                    
//                    
//                    if response.result.isSuccess
//                    {
//                        if let resJson = response.result.value as? NSDictionary
//                        {
//                            if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
//                            {
//                                var message : String?
//                                if responseCode == 0
//                                {
//                                    message = resJson.value(forKey:  "RESPONSE") as? String
//                                    
//                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                        self.actInd.stopAnimating()
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)
//                                }
//                                else if responseCode == 1
//                                {
//                                    message = resJson.value(forKey:  "RESPONSE") as? String
//                                    
//                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                        self.actInd.stopAnimating()
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)                                }
//                                
//                            }
//                        }
//                    }
//                    else if response.result.isFailure
//                    {
//                        print("Response Error")
//                        self.actInd.stopAnimating()
//                    }
//                }
//                
//                //                    }
//                
//            case .failure(let encodingError):
//                //self.delegate?.showFailAlert()
//                print(encodingError)
//                self.actInd.stopAnimating()
//            }
//            
//        }
//    }

    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    @IBAction func btnDeleteAccountClk(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Tuseva", message: "Are you sure you want to delete account", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
            self.isActive = "2"
            self.loginCheck()
//            self.deleteAccount()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteAccount()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//                let userID:String = "5"
        
//        let newString: String = "http://103.36.121.52:82/deve76/tuseva_service/webservices.php?action=delete_account&id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=delete_account&id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
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
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                                self.nextVC()
                                
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
    
    func nextVC()
    {
        UserDefaults.standard.removeObject(forKey: "ID")
        
        if currentReachabilityStatus != .notReachable
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
        }
    
    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8
            , allowLossyConversion: true)
        append(data!)
    }
}
