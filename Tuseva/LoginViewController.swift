//
//  LoginViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 25/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    
    @IBOutlet var btnForgotPass: UIButton!

    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtPin: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var btnNoAccount: UIButton!
    
    var email_fb : String = ""
    var email_gmail : String = ""
    var fb_id : String = ""
    var gmail_id : String = ""
    var fb_firstName : String = ""
    var gmail_firstName : String = ""
    var fb_lastName : String = ""
    var gmail_lastName : String = ""
    
    var fb_image : String = ""
    var gmail_image : String = ""
    
    var isFromGmail:String = ""
    
    var email:String = ""
    var password: String = ""
    
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error as Any)
            return
        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        hideKeyboardWhenTappedAround()
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtMobile.inputAccessoryView = doneToolbar
        self.txtPin.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtMobile.resignFirstResponder()
        self.txtPin.resignFirstResponder()
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        
        btnForgotPass.isUserInteractionEnabled = true

        self.navigationController?.navigationBar.isHidden = true
        
        let txtPinPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtPin.frame.height))
        txtPin.leftView = txtPinPadding
        txtPin.leftViewMode = UITextFieldViewMode.always
        
        let txtMobilePadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtMobile.frame.height))
        txtMobile.leftView = txtMobilePadding
        txtMobile.leftViewMode = UITextFieldViewMode.always
        
        txtPin.layer.cornerRadius = 3.0
        txtMobile.layer.cornerRadius = 3.0
        
        self.btnLogin.layer.cornerRadius = self.btnLogin.frame.height/2.0;
        self.btnGoogle.layer.cornerRadius = self.btnGoogle.frame.height/2.0;
        self.btnFacebook.layer.cornerRadius = self.btnFacebook.frame.height/2.0;
        self.btnNoAccount.layer.cornerRadius = self.btnNoAccount.frame.height/2.0;
        
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }
   
    @IBAction func btnCreateAccountClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(registrationVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
    @IBAction func btnGoogleClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            
            GIDSignIn.sharedInstance().signIn()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let user_email = user.profile.email!
        let user_firstName = user.profile.givenName!
        let fullName = user.profile.name!
        let familyName = user.profile.familyName!
        let userId = user.userID!
        let idToken = user.authentication.idToken!
        let image = user.profile.imageURL(withDimension: 400)
        
        email_gmail = user_email
        gmail_firstName = user_firstName
        gmail_lastName = familyName
        gmail_id = userId
        gmail_image = "\(image!)"
        
        
        print("USER GMAIL ID>>> \(user_email)")
        print("USER FIRSTNAME ID>>> \(user_firstName)")
        print("USER FULLNAME ID>>> \(fullName)")
        print("USER FAMILYNAME ID>>> \(familyName)")
        print("USER USERID ID>>> \(userId)")
        print("USER IDTOKEN ID>>> \(idToken)")
        print("USER IMAGEURL ID>>> \(image!)")

        googleLogin()
        
    }

    func googleLogin()
    {
        actInd.startAnimating()
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=login_with_gmail&gmail_user_id=\(gmail_id)&image=\(gmail_image)".replacingOccurrences(of: " ", with: "%20")
        
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
                            self.isFromGmail = "1"
                            self.gotoRegister()
                        }
                        else if responseCode == 2
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        let userdefaults = UserDefaults.standard
                                        
                                        userdefaults.set(dict.value(forKey:"id"), forKey: "ID")
                                        userdefaults.set(dict.value(forKey:"uid"), forKey: "UID")
                                        
                                        
                                        userdefaults.set(dict.value(forKey:"first_name"), forKey: "first_name")
                                        userdefaults.set(dict.value(forKey:"last_name"), forKey: "last_name")
                                        
                                        userdefaults.set(dict.value(forKey:"mobile"), forKey: "mobile")
                                        
                                        userdefaults.set(dict.value(forKey:"email"), forKey: "email")
                                        
                                        self.email = UserDefaults.standard.value(forKey: "email") as! String
                                        
                                        userdefaults.set(dict.value(forKey:"city"), forKey: "city")
                                        
                                        userdefaults.set(dict.value(forKey: "registration_date"), forKey: "registration_date")
                                        
                                        
                                        
                                        let img = (dict.value(forKey:"profile_pic")) as? String
                                        
                                        userdefaults.set(img, forKey: "image")
                                        
                                        print("image :\(img!)")
                                        
                                        print(dict.value(forKey:"id") ?? 0)
                                        print(dict.value(forKey:"uid") ?? 0)
                                        
                                        
//                                        let strStatus:String = dict.value(forKey: "status") as! String
                                        
                                        self.actInd.stopAnimating()
                                        
                                            message = "Login Successful"
                                            
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
    
    @IBAction func btnFacebookClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
               let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                        if (error == nil){
                            if (result?.isCancelled)! {
                                return
                            }
                            else
                            {
                                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                               
                                if(fbloginresult.grantedPermissions.contains("email"))
                                {
                                    self.getFBUserData()
                                }
                            }
                            
                        }
                    }
//        guard
//            
//            let url = URL(string: "https://www.facebook.com/footballcalendar" )
//            else { return }
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url )
//        } else {
//            UIApplication.shared.openURL(url)
//        }
        
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil)
        {
//            let manager = FBSDKLoginManager()
//            manager.logIn(withReadPermissions: ["user_location"], from: self, handler: nil)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, location, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    let fb_data = result as? NSDictionary
                    self.email_fb = fb_data?["email"] as! String
                    self.fb_firstName = fb_data?["first_name"] as! String
                    self.fb_lastName = fb_data?["last_name"] as! String
                    
//                    UserDefaults.standard.set(self.email_fb, forKey: "email")
//                    UserDefaults.standard.set(self.fb_firstName, forKey: "first_name")
//                    UserDefaults.standard.set(self.fb_lastName, forKey: "last_name")
                    
                    let picture:NSDictionary = fb_data?["picture"] as! NSDictionary
                    let data:NSDictionary = picture.value(forKey: "data") as! NSDictionary
                    
                    let fb_imageURL:String = "\(data.value(forKey: "url")!)"
                    
                    self.fb_image = fb_imageURL
                    
                    let FB_ID:String = fb_data?["id"] as! String
                    
                    self.fb_id = "\(FB_ID)"
                      
                        print("USER >>> \(self.fb_image)")
                    
                        
                        self.facebookLogin()
                      
                    
                }
            })
        }
    }

    
    func facebookLogin()
    {
        actInd.startAnimating()
        
//        let tokenID = UIDevice.current.identifierForVendor?.uuidString
//        UserDefaults.standard.set(tokenID!, forKey: "device_id")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=login_with_facebook&fb_user_id=\(fb_id)&image=\(fb_image)".replacingOccurrences(of: " ", with: "%20")
        
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
                            self.isFromGmail = "0"
                            self.gotoRegister()
                        }
                        else if responseCode == 2
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        let userdefaults = UserDefaults.standard
                                        
                                        userdefaults.set(dict.value(forKey:"id"), forKey: "ID")
                                        userdefaults.set(dict.value(forKey:"uid"), forKey: "UID")
                                        
                                        
                                        userdefaults.set(dict.value(forKey:"first_name"), forKey: "first_name")
                                        userdefaults.set(dict.value(forKey:"last_name"), forKey: "last_name")
                                        
                                        userdefaults.set(dict.value(forKey:"mobile"), forKey: "mobile")
                                        
                                        userdefaults.set(dict.value(forKey:"email"), forKey: "email")
                                        
                                        self.email = UserDefaults.standard.value(forKey: "email") as! String
                                        
                                        userdefaults.set(dict.value(forKey:"city"), forKey: "city")
                                        
                                        userdefaults.set(dict.value(forKey: "registration_date"), forKey: "registration_date")
                                        
                                        
                                        
                                        let img = (dict.value(forKey:"profile_pic")) as? String
                                        
                                        userdefaults.set(img, forKey: "image")
                                        
                                        print("image :\(img!)")
                                        
                                        print(dict.value(forKey:"id") ?? 0)
                                        print(dict.value(forKey:"uid") ?? 0)
                                        
                                        
//                                        let strStatus:String = dict.value(forKey: "status") as! String
                                        
                                        self.actInd.stopAnimating()

                                            message = "Login Successful"
                                            
                                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                                self.gotoNextVC()
                                                self.actInd.stopAnimating()
                                            }))
                                            self.present(alert, animated: true, completion: nil)

                                        
                                        
//                                        self.actInd.startAnimating()
//                                        User.loginUser(withEmail: "\(self.email)", password: self.password) { [weak weakSelf = self](status) in
//                                            DispatchQueue.main.async {
//                                                weakSelf?.actInd.stopAnimating()
//                                                
//                                                if status == true
//                                                {
//                                                    message = "Login Successful"
//                                                    
//                                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                                                        self.gotoNextVC()
//                                                        self.actInd.stopAnimating()
//                                                    }))
//                                                    self.present(alert, animated: true, completion: nil)
//                                                }
//                                                else
//                                                {
//                                                    print(Error.self)
//                                                }
//                                            }
//                                        }
                                        
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
    
    @IBAction func btnForgotPinClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            self.navigationController?.pushViewController(forgotPassVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
    @IBAction func btnLoginClk(_ sender: Any)
    {
        
        if currentReachabilityStatus != .notReachable
        {
            validation()

            print("Internet connection OK")
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
        else if txtPin.text == "" || checkSpace(str: txtPin.text!)
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            login()
            
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
    
    func login()
    {
        actInd.startAnimating()
        let mobNO:String = txtMobile.text!
        let pin:String = txtPin.text!
//        let tokenID: String = "kjh7mnsdfbm98msbnd"
        
        let tokenID = UIDevice.current.identifierForVendor?.uuidString
        UserDefaults.standard.set(tokenID!, forKey: "device_id")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=login_user&mobile_no=\(mobNO)&password=\(pin)&token_id=\(tokenID!)&registration_id=\(tokenID!)&device_type=ios".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
        btnForgotPass.isUserInteractionEnabled = false
        
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
                                self.btnForgotPass.isUserInteractionEnabled = true
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        
                                        let userdefaults = UserDefaults.standard
                                        
                                        userdefaults.set(dict.value(forKey:"id"), forKey: "ID")
                                        userdefaults.set(dict.value(forKey:"uid"), forKey: "UID")
                                        
                                        
                                        userdefaults.set(dict.value(forKey:"first_name"), forKey: "first_name")
                                        userdefaults.set(dict.value(forKey:"last_name"), forKey: "last_name")
                                        
                                        userdefaults.set(dict.value(forKey:"mobile"), forKey: "mobile")
                                        
                                        userdefaults.set(dict.value(forKey:"email"), forKey: "email")
                                        
                                        self.email = UserDefaults.standard.value(forKey: "email") as! String
                                        
                                        self.password = self.txtPin.text!
                                        print("pass:\(self.password)")
                                        
                                        userdefaults.set(dict.value(forKey:"city"), forKey: "city")
                                        
                                        userdefaults.set(dict.value(forKey: "registration_date"), forKey: "registration_date")
                                        
                                        
                                        
                                        let img = (dict.value(forKey:"profile_pic")) as? String
                                        
                                        userdefaults.set(img, forKey: "image")
                                            
                                        print("image :\(img!)")
                                        
                                        print(dict.value(forKey:"id") ?? 0)
                                            print(dict.value(forKey:"uid") ?? 0)
                                        
                                        self.actInd.startAnimating()
                                        User.loginUser(withEmail: "\(self.email)", password: self.password) { [weak weakSelf = self](status) in
                                            DispatchQueue.main.async {
                                                weakSelf?.actInd.stopAnimating()
                                                
//                                                if status == true
//                                                {
                                                    message = "Login Successfully"
                                                    
                                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                                        self.gotoNextVC()
                                                        self.btnForgotPass.isUserInteractionEnabled = true
                                                        self.actInd.stopAnimating()
                                                    }))
                                                    self.present(alert, animated: true, completion: nil)
//                                                }
//                                                else
//                                                {
//                                                    print(Error.self)
//                                                }
                                            }
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
    
    func gotoRegister()
    {
        if currentReachabilityStatus != .notReachable
        {
            let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
            
            if isFromGmail == "0"
            {
                registerVC?.strFirstName = fb_firstName
                registerVC?.strLastName = fb_lastName
                registerVC?.strEmail = email_fb
                registerVC?.isFromLogin = "0"
                registerVC?.strfbid = fb_id
                registerVC?.strImage = fb_image
            }
            else
            {
                registerVC?.strFirstName = gmail_firstName
                registerVC?.strLastName = gmail_lastName
                registerVC?.strEmail = email_gmail
                registerVC?.isFromLogin = "2"
                registerVC?.strgmailid = gmail_id
                registerVC?.strImage = gmail_image
            }
            
            self.navigationController?.pushViewController(registerVC!, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
    func gotoNextVC()
    {
        if currentReachabilityStatus != .notReachable
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
            self.navigationController?.pushViewController(secondViewController!, animated: true)
            
//            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
//            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
}
