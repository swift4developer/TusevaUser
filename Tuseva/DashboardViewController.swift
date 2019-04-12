



//
//  DashboardViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 26/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class DashboardViewController: UIViewController, SWRevealViewControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ConstrainOffer: NSLayoutConstraint!
    
    @IBOutlet var ConstrainContactUs: NSLayoutConstraint!
    
    @IBOutlet var btnServiceProvider: UIButton!
    
    @IBOutlet var btnOfferDiscount: UIButton!
    
    @IBOutlet var btnMyQuery: UIButton!
    @IBOutlet var btnMyVehicle: UIButton!
    @IBOutlet var btnBuyVehicle: UIButton!
    @IBOutlet var btnServiceModify: UIButton!

    @IBOutlet var btnOffer: UIButton!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var btnServiceReminder: UIButton!
    @IBOutlet var viewScroll: UIView!
    @IBOutlet var viewSearchTxt: UIView!
    var strBtnClicked: String = ""
    @IBOutlet var scroll_view: UIScrollView!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var txtSearch: UITextField!
    
    @IBOutlet var imgFacebook: UIImageView!
    
    @IBOutlet var imgSkype: UIImageView!
    @IBOutlet var imgGoogle: UIImageView!
    @IBOutlet var imgTwitter: UIImageView!
    
    var CityName: NSString = ""
    
    var arrSelectCity = [responseArraySelectCity]()
    var cityID:String = ""
    
    var tblViewSearch = UITableView()

    let locationManager = CLLocationManager()
    
    var actInd = UIActivityIndicatorView()
    
    
    var dictOffer = NSMutableDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTapFacebook))
        imgFacebook.isUserInteractionEnabled = true
        imgFacebook.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(handleTapTwitter))
        imgTwitter.isUserInteractionEnabled = true
        imgTwitter.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(handleTapGoogle))
        imgGoogle.isUserInteractionEnabled = true
        imgGoogle.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action:#selector(handleTapSkype))
        imgSkype.isUserInteractionEnabled = true
        imgSkype.addGestureRecognizer(tap3)
        
        if txtSearch.text != ""
        {
            CheckCity(city:CityName as String)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tblViewSearch.frame = CGRect(x:viewSearchTxt.frame.origin.x, y:viewSearchTxt.frame.origin.y + viewSearchTxt.frame.size.height, width: viewSearchTxt.frame.size.width, height: 200)
        
        self.viewScroll.addSubview(tblViewSearch)
        
        tblViewSearch.isHidden = true
        
        tblViewSearch.delegate = self
        tblViewSearch.dataSource = self
        
        tblViewSearch.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        let filterImage   = UIImage(named: "filter")!
        
//        let img = UserDefaults.standard.value(forKey: "image") as? String
        let navUserImage = UIImage(named: "nav_user")?.withRenderingMode(.alwaysOriginal)
        let  imgView = UIImageView(image: navUserImage)
        imgView.frame =   CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let menuBtn = UIBarButtonItem(image: navUserImage, landscapeImagePhone: navUserImage, style: .plain, target: self, action: #selector(DashboardViewController.didTapMenuButton(sender:)))
        
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Dashboard"
        self.navigationItem.leftBarButtonItem = menuBtn
        
         self.navigationController?.navigationBar.isHidden = false
        
        
    
        if UserDefaults.standard.value(forKey: "ID") != nil
        {
            CityName = UserDefaults.standard.value(forKey: "city") as! NSString
            
            txtSearch.text = CityName as String
        }
        else
        {
            
        }
        
        if currentReachabilityStatus != .notReachable
        {
//            // Ask for Authorisation from the User.
//            self.locationManager.requestAlwaysAuthorization()
//            
//            // For use in foreground
//            self.locationManager.requestWhenInUseAuthorization()
//            
//            if CLLocationManager.locationServicesEnabled() {
//                locationManager.delegate = self
//                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                locationManager.startUpdatingLocation()
//            }

            selectCity()
            
            showOffer()
            
            
           
            
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        actInd.stopAnimating()
        self.navigationController?.navigationBar.isHidden = false
    }


    func handleTapFacebook()
    {
        guard let url = URL(string: "https://www.facebook.com/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func handleTapTwitter()
    {
        guard let url = URL(string: "https://twitter.com") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func handleTapGoogle()
    {
        guard let url = URL(string: "http://www.google.com") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func handleTapSkype()
    {
        guard let url = URL(string: "https://www.skype.com/en/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        
//        // Add below code to get address for touch coordinates.
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//            
//            // Address dictionary
//            print(placeMark.addressDictionary as Any)
//            
//            // Location name
//            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
//                print(locationName)
//            }
//            // Street address
//            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//                print(street)
//            }
//            // City
//            if let city = placeMark.addressDictionary!["SubAdministrativeArea"] as? NSString
//            {
//                // City
//                
//                self.CityName = city
//                
//                self.txtSearch.text = city as String
//                print(city)
//            }
//            // Zip code
//            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                print(zip)
//            }
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
//        })
//        
//        
//    }
    
    
    func CheckCity(city:String)
    {
        actInd.startAnimating()
//        let mobNO:String = txtMobileNumber.text!
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=check_city_user&city=\(city)")!
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
                            self.actInd.stopAnimating()
                            self.showSorryPopUp()
                        }
                        else if responseCode == 1
                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            message = "service is provided to your city"
                            
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
                                    self.tblViewSearch.reloadData()
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
        
    func didTapMenuButton(sender: AnyObject)
    {
        if currentReachabilityStatus != .notReachable
        {
            print("Internet connection OK")
//            if UserDefaults.standard.value(forKey: "ID") != nil
//            {
                self.revealViewController().revealToggle(sender)
//            }
//            else
//            {
//                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                    self.gotoNextVC()
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    func didTapFilterButton(sender: AnyObject)
    {
        if currentReachabilityStatus != .notReachable
        {
            print("Filter btn tapped")
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    @IBAction func btnSearchClk(_ sender: Any)
    {
        if tblViewSearch.isHidden == true
        {
            tblViewSearch.isHidden = false
        }
        else
        {
            tblViewSearch.isHidden = true
        }
    }
    
    func showSorryPopUp()
    {
        
        self.actInd.stopAnimating()
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let popVC = self.storyboard?.instantiateViewController(withIdentifier: "pop") as? PopUpViewController
                
                var frame: CGRect = popVC!.view.frame;
                frame.size.width = UIScreen.main.bounds.size.width
                frame.size.height = UIScreen.main.bounds.size.height
                popVC?.view.frame = frame;
                
                self.addChildViewController(popVC!)
                self.view.addSubview((popVC?.view)!)
                popVC?.didMove(toParentViewController: self)
                
                //        self.navigationController?.pushViewController(popVC!, animated: true)
                
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
            
        }

    }
    
    @IBAction func btnServiceVehicleClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            
//            if UserDefaults.standard.value(forKey: "ID") != nil
//            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "serviceVC") as? ServiceAndModifyVC
                serviceVC?.strClick = "service"
                self.navigationController?.pushViewController(serviceVC!, animated: true)
//            }
//            else
//            {
//                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                    self.gotoNextVC()
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
        
    }
    
    
    @IBAction func btnBuyNewVehicleClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "serviceVC") as? ServiceAndModifyVC
                serviceVC?.strClick = "buy"
                self.navigationController?.pushViewController(serviceVC!, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    @IBAction func btnMyVehicleClk(_ sender: Any) {
    }

    @IBAction func btnMyQeuryClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as? PreviousQueryVC
                self.navigationController?.pushViewController(serviceVC!, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    @IBAction func btnServiceReminderClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {                
                
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceReminderListViewController") as? ServiceReminderListViewController
                self.navigationController?.pushViewController(serviceVC!, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
        
    }
    
    @IBAction func btnJoinUsClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinUSViewController") as? JoinUSViewController
                self.navigationController?.pushViewController(serviceVC!, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    @IBAction func btnContctUsClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let contctVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(contctVC, animated: true)
                
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    @IBAction func btnAdsClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                goToOffer()
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }
    
    
    
    func showOffer()
    {
        var strCity:String = ""
        if txtSearch.text == "Search City"
        {
          strCity = self.txtSearch.text!
        }
        else
        {
            strCity = ""
        }
        actInd.startAnimating()
        //        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=offer_discount")!
        
        let url : URLConvertible = URL(string:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=advertisement_user&city=\(strCity)")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
//                        var message : String?
                        if responseCode == 0
                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                self.actInd.stopAnimating()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
                            
                            self.btnOfferDiscount.isHidden = true
                            
                            self.ConstrainOffer.isActive = false
                            self.ConstrainContactUs.isActive = true
                            
                            self.ConstrainContactUs.constant = 10
                            
                        }
                        else if responseCode == 1
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        
                                        self.dictOffer = dict as! NSMutableDictionary
                                        
//                                        self.lblOffer.text = dict.value(forKey:"title") as? String
//                                        self.lblOfferDesc.text = dict.value(forKey:"description") as? String
//                                        self.lblPhoneNo.text = dict.value(forKey:"mobile") as? String
//                                        
//                                        let imgURL = dict.value(forKey:"image")
//                                        self.imgVehicle.setImageFromURl(stringImageUrl: imgURL as! String)
//                                        
//                                        self.strlink = dict.value(forKey: "link") as! String
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            self.btnOfferDiscount.isHidden = false
                            
                            self.ConstrainOffer.isActive = true
                            self.ConstrainContactUs.isActive = false
                            
                            self.ConstrainContactUs.constant = 116
//                            self.goToOffer()
                            self.actInd.stopAnimating()
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

    func goToOffer()
    {
        let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "ad_pop") as? AdPopUpViewController
        
        var frame: CGRect = popAdVC!.view.frame;
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        popAdVC?.view.frame = frame;
        
        popAdVC?.strCity = self.txtSearch.text!
        popAdVC?.dict = self.dictOffer
        
        self.addChildViewController(popAdVC!)
        self.view.addSubview((popAdVC?.view)!)
        popAdVC?.didMove(toParentViewController: self)

    }
    
    @IBAction func btnServiceProviderClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let contctVC = self.storyboard?.instantiateViewController(withIdentifier: "ListOfServiceProviderVC") as! ListOfServiceProviderVC
                self.navigationController?.pushViewController(contctVC, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }

    }
    
    @IBAction func btnAboutUsClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let contctVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                self.navigationController?.pushViewController(contctVC, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
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
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            alert()
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

        txtSearch.text = arrSelectCity[indexPath.row].cityName
        
        cityID = arrSelectCity[indexPath.row].cityID!
        
        CheckCity(city: txtSearch.text!)
        
        tblViewSearch.isHidden = true
        
    }
}

class responseArraySelectCity
{
    var cityName:String?
    var cityID:String?
    
    init(cityName:String, cityID:String)
    {
        self.cityName = cityName
        self.cityID = cityID
    }
    
    
}
