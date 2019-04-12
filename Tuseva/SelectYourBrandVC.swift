
//
//  SelectYourBrandVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 02/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class SelectYourBrandVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnConfused: UIButton!
    
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
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(SelectYourBrandVC.didTapBackButton(sender:)))
        
        let settingBtn = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(SelectYourBrandVC.didTapSettingButton(sender:)))
        
        let searchBtn = UIBarButtonItem(image: searchImage, landscapeImagePhone: searchImage, style: .plain, target: self, action: #selector(SelectYourBrandVC.didTapSearchButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Select Your Brand"
        self.navigationItem.rightBarButtonItems = [settingBtn, searchBtn]
        self.navigationItem.leftBarButtonItem = backBtn
        
        btnConfused.layer.cornerRadius = btnConfused.frame.size.height / 2
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            selectBrandType()
        }
        else
        {
            alert()
        }
    }
    
    func didTapSettingButton(sender: AnyObject){
        
        print("Setting btn tapped")
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
                            self.selectBrandType()
                            
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
    
    func selectBrandType()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_brand_for_buy&vehicle_id=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
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
    
    @IBAction func btnConfusedClk(_ sender: Any) {
        
        let popVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpCallVC2") as? PopUpCallVC2
        
        var frame: CGRect = popVC!.view.frame;
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        popVC?.view.frame = frame;
        
        self.addChildViewController(popVC!)
        self.view.addSubview((popVC?.view)!)
        popVC?.didMove(toParentViewController: self)
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectBrand.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableCell2
        
        let imgURL = selectBrand[indexPath.row].image
        cell.imgVehicle.setImageFromURl(stringImageUrl: imgURL!)
        cell.imgVehicle.layer.cornerRadius = cell.imgVehicle.frame.size.height / 2
        cell.imgVehicle.clipsToBounds = true
        
        cell.lblName.text = selectBrand[indexPath.row].brandType
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! tableCell2
//        cell.contentView.backgroundColor = UIColor(red:0.05, green:0.53, blue:0.84, alpha:1.0)
        
//        cell.isUserInteractionEnabled = true
        
//        cell.lblName.textColor = UIColor.white
        
        strBrandID = selectBrand[indexPath.row].brandID!
        
        UserDefaults.standard.set(strBrandID, forKey: "BrandIDServiceBuy")
        
        if currentReachabilityStatus != .notReachable
        {
            let fuelVC = self.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
            fuelVC.barTitle = cell.lblName.text!
            self.navigationController?.pushViewController(fuelVC, animated: true)
            
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

        
        
    }
    
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! tableCell2
//        cell.contentView.backgroundColor = UIColor.white
//        cell.lblName.textColor = UIColor.black
//    }
 
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
   
    func didTapSearchButton(sender: AnyObject){
        
        print("Search btn tapped")
    }
    
}


class tableCell2 : UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVehicle: UIImageView!
}
