//
//  SelectBrandVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 27/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class SelectBrandVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var carImages = [UIImage]()
    var carNames = [String]()
    var getClicked : String = ""
    
    var strLink:String = ""
    var strCity:String = ""
    var strVehicleID : String = ""
    
    @IBOutlet var imgVehicle: UIImageView!
    @IBOutlet var brandTableView: UITableView!
    var selectBrand = [responseArrayBrand]()
    var strBrandID:String = ""
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        let settingImage   = UIImage(named: "setting")!
        let searchImage = UIImage(named: "search_white")!
        let backImage = UIImage(named: "backbtn")!
                
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(SelectBrandVC.didTapBackButton(sender:)))
        
        let settingBtn = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(SelectBrandVC.didTapSettingButton(sender:)))
        
        let searchBtn = UIBarButtonItem(image: searchImage, landscapeImagePhone: searchImage, style: .plain, target: self, action: #selector(SelectBrandVC.didTapSearchButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Select Your Brand"
        self.navigationItem.rightBarButtonItems = [settingBtn, searchBtn]
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(handleTapImage))
        imgVehicle.isUserInteractionEnabled = true
        imgVehicle.addGestureRecognizer(tap1)
        
        if currentReachabilityStatus != .notReachable
        {
//            loginCheck()
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                showOffer()
            }

            selectBrandType()
        }
        else
        {
            alert()
        }
        
    }
    
    func handleTapImage()
    {
        guard let url = URL(string: strLink) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
//                        //                        if self.isActive == "1"
//                        //                        {
//                        //                            self.brandType()
//                        //                        }
//                        //
//                        //                        else
//                        //                        {
//                        if UserDefaults.standard.value(forKey: "ID") != nil
//                        {
//                            self.showOffer()
//                        }
//                        
//                        self.selectBrandType()
//                        //                        }
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

    
    func showOffer()
    {
        actInd.startAnimating()
        //        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=offer_discount")!
        
        
        strCity = UserDefaults.standard.value(forKey: "city") as! String
        let url : URLConvertible = URL(string:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=advertisement_user&city=\(strCity)")!
        
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
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                self.actInd.stopAnimating()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        
//                                        self.lblOffer.text = dict.value(forKey:"title") as? String
//                                        self.lblOfferDesc.text = dict.value(forKey:"description") as? String
//                                        self.lblPhoneNo.text = dict.value(forKey:"mobile") as? String
                                        
                                        let imgURL = dict.value(forKey:"image")
                                        self.imgVehicle.setImageFromURl(stringImageUrl: imgURL as! String)
                                        
                                        self.strLink = dict.value(forKey: "link") as! String
                                        
                                        self.strVehicleID = dict.value(forKey: "vehicle_id") as! String
                                        
                                        if self.strVehicleID == UserDefaults.standard.value(forKey: "VehicleIDService") as! String
                                        {
                                            self.imgVehicle.isHidden = false
                                            
                                            var frame:CGRect = self.brandTableView.frame
                                            frame.origin.y = self.imgVehicle.frame.origin.y + self.imgVehicle.frame.size.height
                                            self.brandTableView.frame = frame
                                        }
                                        else
                                        {
                                            self.imgVehicle.isHidden = true
                                            
                                            var frame:CGRect = self.brandTableView.frame
                                            frame.origin.y = self.imgVehicle.frame.origin.y
                                            frame.size.height = self.brandTableView.frame.size.height + self.imgVehicle.frame.size.height
                                            self.brandTableView.frame = frame
                                        }
                                        
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

    
    func selectBrandType()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_brand_for_service&vehicle_id=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectBrand.removeAll()
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
                                    
                                    guard let brand_name = arrData["brand_name"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["brand_id"] as? String
                                    print("ID>>>\(id!)")
                                    
                                    let image = arrData["image"] as? String
                                    
                                    let r = responseArrayBrand(brandType:brand_name, brandID:id!, image:image!)
                                    
                                    self.selectBrand.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.brandTableView.reloadData()
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
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    func didTapSettingButton(sender: AnyObject){
        
        print("Setting btn tapped")
    }
    func didTapSearchButton(sender: AnyObject){
        
        print("Search btn tapped")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectBrand.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableCell
        
//        let strBrand:String? = selectBrand[indexPath.row].brandType
        
        cell.lblName.text = selectBrand[indexPath.row].brandType
        
        let imgURL = selectBrand[indexPath.row].image
        cell.imgVehicle.setImageFromURl(stringImageUrl: imgURL!)
        cell.imgVehicle.layer.cornerRadius = cell.imgVehicle.frame.size.height / 2
        cell.imgVehicle.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! tableCell
        
        cell.contentView.backgroundColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0)
        cell.lblName.textColor = UIColor.white

        
        strBrandID = selectBrand[indexPath.row].brandID!
                
        UserDefaults.standard.set(strBrandID, forKey: "BrandIDService")
        
        if currentReachabilityStatus != .notReachable
        {
            let fuelVC = self.storyboard?.instantiateViewController(withIdentifier: "fuel") as! FuelModelVarientVC
            fuelVC.barTitle = cell.lblName.text!
            self.navigationController?.pushViewController(fuelVC, animated: true)

        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! tableCell
        cell.contentView.backgroundColor = UIColor.white
        cell.lblName.textColor = UIColor.black
    }

}


class tableCell : UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVehicle: UIImageView!
}
