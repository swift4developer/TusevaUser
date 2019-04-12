//
//  ServiceAndModifyVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 27/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ServiceAndModifyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var strClick: String = ""
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var twoWheelerView: UIView!
    @IBOutlet var fourWheelerView: UIView!
    
    var selectVehicle = [responseArrayVehicle]()
    var strVehicleID : String = ""
    
    @IBOutlet var tblView: UITableView!
    
    var actInd = UIActivityIndicatorView()
    
    var isReveal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twoWheelerView.layer.cornerRadius = 2
        fourWheelerView.layer.cornerRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let filterImage   = UIImage(named: "setting")!
//        let menuImage = UIImage(named: "menu")!
        //        let navUserImage = UIImage(named: "nav_user")?.withRenderingMode(.alwaysOriginal)
        //        let  imgView = UIImageView(image: navUserImage)
        //        imgView.frame =   CGRect(x: 0, y: 0, width: 40, height: 40)
        
        //        let leftBtn = UIBarButtonItem.init(customView: imgView)
        
        
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ServiceAndModifyVC.didTapBackButton(sender:)))
                navigationItem.leftBarButtonItem = backBtn
        
        
        
//        let menuBtn   = UIBarButtonItem(image: menuImage, landscapeImagePhone: menuImage, style: .plain, target: self, action: #selector(ServiceAndModifyVC.didTapMenuButton(sender:)))
        
        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ServiceAndModifyVC.didTapFilterButton(sender:)))
        
       
        
        self.navigationItem.title = "TUSEVA"
        self.navigationItem.rightBarButtonItem = filterBtn
//        self.navigationItem.leftBarButtonItem = menuBtn
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if currentReachabilityStatus != .notReachable
        {
//            loginCheck()
            selectVehicleType()
            Description()
        }
        else
        {
            alert()
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
    
//    func didTapMenuButton(sender: AnyObject){
//
//        self.revealViewController().revealToggle(sender)
//
//    }
    func didTapFilterButton(sender: AnyObject){
        
        print("Setting btn tapped")
    }
    
    

    
    
    
    
//    func loginCheck()  {
//        
//        let id:String = UserDefaults.standard.value(forKey: "ID") as! String
//        
//        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=logincheck&user_id=\(id)")!
//        
//        print("URL>\(url)")
//        
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            
//            if response.result.isSuccess
//            {
//                if let resJson = response.result.value as? NSDictionary
//                {
//                    let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
//                    
//                    if responseCode == 0
//                    {
//                        let message = resJson.value(forKey:  "RESPONSE") as? String
//                        
//                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                        
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
//                            
//                            
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    else if responseCode == 1
//                    {
//                        print("Success")
//                        
////                        if self.isActive == "1"
////                        {
////                            self.brandType()
////                        }
////                        
////                        else
////                        {
//                            self.selectVehicleType()
//                            self.Description()
////                        }
//                        
//                    }
//                }
//            }
//            else if response.result.isFailure
//            {
//                
//                if let error = response.result.error
//                {
//                    print("Response Error \(error.localizedDescription)")
//                    
//                }
//                
//            }
//        }
//    }

    
    func Description()
    {
        actInd.startAnimating()
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=description".replacingOccurrences(of: " ", with: "%20")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=manage_mobile_cms".replacingOccurrences(of: " ", with: "%20")
        
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
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
                            {
                                for arrData in resValue {
                                    
                                    if self.strClick == "buy"
                                    {
                                    
                                        self.lblDescription.text = arrData["description_buy"] as? String
                                        
                                        self.lblTitle.text = arrData["title_buy"] as? String
                                    }
                                    else
                                    {
                                        self.lblDescription.text = arrData["description_service"] as? String
                                        
                                        self.lblTitle.text = arrData["title_service"] as? String
                                    }
                                }
                                
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

    
    func selectVehicleType()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_vehicle_carDealer".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectVehicle.removeAll()
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
                                    
                                    guard let vehicle_type = arrData["vehicle_type"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["vehicleid"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayVehicle(vehicleType:vehicle_type, vehicleID:id!)
                                    
                                    self.selectVehicle.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.tblView.reloadData()
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
    
    @IBAction func btn2WheelerClk(_ sender: Any) {
        twoWheelerView.backgroundColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0)
        fourWheelerView.backgroundColor = UIColor.white
        
        if strClick == "buy" {
        
            let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourBrandVC") as? SelectYourBrandVC
            self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
        } else {
        
            let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandVC") as? SelectBrandVC
            self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
        }
       
    }
   
    @IBAction func btn4WheelerClk(_ sender: Any) {
        fourWheelerView.backgroundColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0)
        twoWheelerView.backgroundColor = UIColor.white
        
        if strClick == "buy" {
            
            let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourBrandVC") as? SelectYourBrandVC
            self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
        } else {
            
            let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandVC") as? SelectBrandVC
            self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectVehicle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! selectVehicleTableViewCell
        
        let strVehicle:String? = selectVehicle[indexPath.row].vehicleType
        
        cell.lblVehicleType.setTitle(strVehicle, for: UIControlState.normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)
        
        strVehicleID = selectVehicle[indexPath.row].vehicleID!
        
        let userdefaults = UserDefaults.standard

        userdefaults.set(strVehicleID, forKey: "VehicleIDService")
                
        if currentReachabilityStatus != .notReachable
        {
            if strClick == "buy" {
                
                let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourBrandVC") as? SelectYourBrandVC
                self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
            } else {
                
                let SelectBrandVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandVC") as? SelectBrandVC
                self.navigationController?.pushViewController(SelectBrandVC!, animated: true)
            }

        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
    }

    
}

class selectVehicleTableViewCell:UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgVehicle: UIImageView!
    @IBOutlet var lblVehicleType: UIButton!
    
}
