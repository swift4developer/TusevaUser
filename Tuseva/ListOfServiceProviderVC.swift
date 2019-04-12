//
//  ListOfServiceProviderVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 31/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ListOfServiceProviderVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {

//    var locationName : [String] = ["Bhopal", "Indore","Betul","Gwalior","Vidisha"]
    var locationTblView = UITableView()
    
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var viewLocation: UIView!
    @IBOutlet var btnLoc: UIButton!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblLocation: UILabel!
    
    @IBOutlet var lblName: UITextField!
    @IBOutlet var myProgressBar: UIProgressView!
    @IBOutlet var lblDistance: UILabel!
    
    var strLat:String = ""
    var strLong:String = ""
    
    let locationManager = CLLocationManager()
    
    var strDistance:String = ""
    
    let step:Float=1 // If you want UISlider to snap to steps by 10
    
    @IBOutlet var Slider: UISlider!
    var arrSelectCity = [responseArraySelectCity]()
    var strCityID:String = ""
    
    var arrSPList = [responseArraySPList]()
    var strSpID:String = ""
    
    var strName:String = ""
    var strLocation:String = ""
    
    var isReveal:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        myProgressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        
        locationTblView.isHidden = true
        
        locationTblView.delegate = self
        locationTblView.dataSource = self
        
        locationTblView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Slider.minimumValue = 0
        Slider.maximumValue = 100
        Slider.isContinuous = true
        
        lblDistance.text = ""
        
        let txtFirstPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.lblName.frame.height))
        lblName.leftView = txtFirstPadding
        lblName.leftViewMode = UITextFieldViewMode.always
        
        let filterImage   = UIImage(named: "filter")!
//        let menuImage = UIImage(named: "backbtn")!
        
        
        let backImage = UIImage(named: "backbtn")!
        
        let menuBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ListOfServiceProviderVC.didTapMenuButton(sender:)))
        
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = menuBtn
        
//        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ListOfServiceProviderVC.didTapFilterButton(sender:)))
        
//        let menuBtn = UIBarButtonItem(image: menuImage, landscapeImagePhone: menuImage, style: .plain, target: self, action: #selector(ListOfServiceProviderVC.didTapMenuButton(sender:)))
//        
//        
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "List Of Service Providers"
//        self.navigationItem.rightBarButtonItem = filterBtn
//        self.navigationItem.leftBarButtonItem = menuBtn
        
        
        locationTblView.frame = CGRect(x: self.viewLocation.frame.origin.x , y:  self.viewLocation.frame.origin.y + viewLocation.frame.size.height, width: self.viewLocation.frame.size.width, height: 100)
        locationTblView.estimatedRowHeight = 60
        self.viewSearch.addSubview(locationTblView)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if currentReachabilityStatus != .notReachable
        {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            
            loginCheck(isActive: "")

//            selectCity()
//            
//            serviceProviderList()
        }
        else
        {
            alert()
        }
        
        
        hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        strLat = "\(locValue.latitude)"
        strLong = "\(locValue.longitude)"
    }
    
    //--- *** ---//
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ListOfServiceProviderVC.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.lblName.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.lblName.resignFirstResponder()
    }
    
    
    func didTapMenuButton(sender: AnyObject)
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

            self.navigationController?.popViewController(animated: true)
        //        self.revealViewController().revealToggle(sender)
        }
    }
    func didTapFilterButton(sender: AnyObject){
        
        print("Filter btn tapped")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        lblName.resignFirstResponder()
        return true
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
                        
                        if isActive == "1"
                        {
                            self.serviceProviderList()
                        }
//                        else if isActive == "2"
//                        {
//                            self.varientType()
//                        }
//                        else if isActive == "4"
//                        {
//                            self.createQueryBuy(shareCnt: "1")
//                        }
//                        else if isActive == "5"
//                        {
//                            self.createQueryBuy(shareCnt: "0")
//                        }
                        else
                        {
                            self.selectCity()
                            
                            self.serviceProviderList()
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

    
    @IBAction func btnSearchClk(_ sender: Any)
    {
        loginCheck(isActive: "1")
//        serviceProviderList()
    }
    
    @IBAction func btnLocationClk(_ sender: Any)
    {
        if (locationTblView.isHidden == true ) {
            locationTblView.isHidden = false
        }
        else
        {
            locationTblView.isHidden = true
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
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
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
                                    self.locationTblView.reloadData()
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
    
    @IBAction func SliderValueChange(_ sender: UISlider!)
    {
        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        print("Slider step value \(Int(roundedStepValue))")
        
        lblDistance.text = "\(roundedStepValue) KM Distance"
        
        strDistance = "\(roundedStepValue)"
    }
    

    func serviceProviderList()
    {
        actInd.startAnimating()
        strName = lblName.text!
        var strCity:String = ""
        
        if lblLocation.text == "Location"
        {
            strLocation = ""
            strCity = ""
        }
        else
        {
            strLocation = lblLocation.text!
            strCity = lblLocation.text!
        }
        
        if lblDistance.text == ""
        {
            strDistance = "0"
        }
        
        let str:String = "\(strName) \(strLocation)"
        
        let userID  = UserDefaults.standard.value(forKey: "ID") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=service_stations_list&user_id=\(userID)&service_station_name=\(str)&city=\(strCity)&latitude=\(strLat)&longitude=\(strLong)&distance=\(strDistance)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrSPList.removeAll()
                    
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
                                    
//                                    let spName = self.nullToNil(value: arrData["sp_name"] as? AnyObject)
                                    
                                    let spName = arrData["sp_name"] as? String
                                    
                                    let spAddress = arrData["sp_address"] as? String
                                    let spMobile = arrData["sp_mobile"] as? String
                                    let verified = arrData["verified"] as? String
                                    
//                                    guard let rating = arrData["rating"] as? String else {
//                                        return
//                                    }
                                    
                                    let strrating:Int = arrData["rating"] as! Int
                                    
                                    let rating:String = "\(strrating)"

                                    
                                    let like:String = arrData["like"] as! String
                                    
                                    let strLike:String = "\(like)"


                                    
                                    let reviewcount:Int = arrData["reviewcount"] as! Int
                                    
                                    let strReviewcount:String = "\(reviewcount)"
                                    
                                    let image = arrData["image"] as? String
                                    
                                    let id = arrData["sp_id"] as? String
                                    print("ID>>>\(id!)")
                                    
                                    let r = responseArraySPList(spName:spName! , spAddress:spAddress!, spMobile:spMobile!,verified:verified!, rating:rating,like:strLike, reviewCount:strReviewcount, image:image!, spID:id!)
                                    
                                    self.arrSPList.append(r)
                                }
                                
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.tblView.reloadData()
                            self.actInd.stopAnimating()
                        })
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
    
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
//            if value == nil
//            {
//                value = ""
//            }
        } else {
            return value
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == locationTblView
        {
            return arrSelectCity.count
        }
        else
        {
            return arrSPList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == locationTblView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = arrSelectCity[indexPath.section].cityName
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myTableViewCell
            
            cell.lblServiceStationName.text = arrSPList[indexPath.section].spName
            cell.lblNumber.text = arrSPList[indexPath.section].spMobile
            cell.lblSelectedLocation.text = arrSPList[indexPath.section].spAddress
            
            if arrSPList[indexPath.section].verified == "0"
            {
                cell.imgVerified.isHidden = true
            }
            else
            {
                cell.imgVerified.isHidden = false
            }
            
            
            if arrSPList[indexPath.section].like == "0"
            {
                cell.btnLike.setImage(UIImage(named:"like"), for: UIControlState.normal)
            }
            else
            {
                cell.btnLike.setImage(UIImage(named:"filled_heart"), for: UIControlState.normal)
            }
            
            cell.btnLike.buttonIndex = indexPath
            
            cell.btnLike.addTarget(self,action:#selector(btnLikeClk(sender:)), for: .touchUpInside)
            
            let imgURL = arrSPList[indexPath.section].image
            cell.imgCar.setImageFromURl(stringImageUrl: imgURL!)
            
            let strReview = arrSPList[indexPath.section].reviewCount
            cell.lblReviews.text = "Base on \(strReview!) review"
            
            let strRating = arrSPList[indexPath.section].rating
            cell.lblRating.text = "\(strRating!)/5"
            
            return cell
        }
    }
    
    func btnLikeClk(sender:CustomButton)
    {
//        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tblView.cellForRow(at: sender.buttonIndex) as! myTableViewCell
        
        let strSpId = arrSPList[sender.tag].spID
        
        // call webservice
        
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
        
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=add_like&user_id=\(userID)&sp_id=\(strSpId!)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
                        if responseCode == 0
                        {
                            let alert = UIAlertController(title: "Tuseva", message: "Something went wrong", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
                            let isLike = resJson.value(forKey:  "RESPONSELIKE") as? Bool
                            
                            if isLike == true
                            {
                                cell.btnLike.setImage(UIImage(named:"filled_heart"), for: UIControlState.normal)
                            }
                            else
                            {
                                cell.btnLike.setImage(UIImage(named:"like"), for: UIControlState.normal)
                            }
                            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == locationTblView  {
            return 0
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == locationTblView {
            tableView.cellForRow(at: indexPath)
            lblLocation.text = arrSelectCity[indexPath.section].cityName
            
            strCityID = arrSelectCity[indexPath.section].cityID!
            locationTblView.isHidden = true
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myTableViewCell
            
            cell.backgroundColor = UIColor(red:1.00, green:0.87, blue:0.87, alpha:1.0)
            let serviceSationVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceStationNameVC") as! ServiceStationNameVC
            
            strSpID = arrSPList[indexPath.section].spID!
            
            serviceSationVC.strSpID = strSpID
            
            self.navigationController?.pushViewController(serviceSationVC, animated: true)
        }
    }
}

class myTableViewCell: UITableViewCell {

    @IBOutlet var lblSelectedLocation: UILabel!
    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblServiceStationName: UILabel!
    @IBOutlet var imgVerified: UIImageView!
    @IBOutlet var lblReviews: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var btnLike: CustomButton!
    
}


class responseArraySPList
{
    var spName:String?
    var spAddress:String?
    var spMobile:String?
    var verified:String?
    var rating:String?
    var like:String?
    var reviewCount:String?
    var image:String?
    var spID:String?
    
    init(spName:String, spAddress:String, spMobile:String,verified:String, rating:String,like:String, reviewCount:String, image:String, spID:String)
    {
        self.spName = spName
        self.spAddress = spAddress
        self.spMobile = spMobile
        self.verified = verified
        self.rating = rating
        self.like = like
        self.reviewCount = reviewCount
        self.image = image
        self.spID = spID
    }
    
    
}
