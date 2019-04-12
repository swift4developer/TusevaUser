//
//  VehicleDetailViewController.swift
//  Tuseva
//
//  Created by oms183 on 11/9/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class VehicleDetailViewController: UIViewController {
    
    @IBOutlet var btnTwoWheeler: UIButton!
    
    @IBOutlet var btnFourWheeler: UIButton!
    
    @IBOutlet var imgVehicle: UIImageView!
    
    @IBOutlet var lblPetrol: UILabel!
    
    @IBOutlet var lblModel: UILabel!
    
    @IBOutlet var lblBrand: UILabel!
    
    @IBOutlet var lblVarient: UILabel!
    
    @IBOutlet var btnUpdate: UIButton!
    
    @IBOutlet var btnDelete: UIButton!
    
    
    
    var strVehicleID:String = ""
    var isActive:String = ""
    
    var actInd = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(AddManageVehicleVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Vehicle Details"
        self.navigationItem.leftBarButtonItem = backBtn
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        imgVehicle.layer.cornerRadius = imgVehicle.layer.frame.size.height / 2
        imgVehicle.clipsToBounds = true
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck()
        }
        else
        {
            alert()
        }
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
                        
                        if self.isActive == "2"
                        {
                            self.deleteVehicle()
                        }
//                        else if self.isActive == "2"
//                        {
//                            self.deleteAccount()
//                        }
//                        else if self.isActive == "3"
//                        {
//                            self.myImageUploadRequest()
//                        }
                        else
                        {
                            self.getVehicleDetail()
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

    func getVehicleDetail()
    {
        actInd.startAnimating()
        
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=users_vehicle_detail&user_id=\(userID)&vehicle_id=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString)!
        
        print("URL>>>>>>\(url)")
        
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
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        self.lblBrand.text = dict.value(forKey: "brand") as? String
                                        
                                        self.lblModel.text = dict.value(forKey: "model") as? String
                                        
                                        self.lblPetrol.text = dict.value(forKey: "fuel") as? String
                                        
                                        self.lblVarient.text = dict.value(forKey: "varient") as? String
                                        
                                        let strWheeler = dict.value(forKey: "vehicle") as! String
                                        
                                        if strWheeler == "2 Wheeler"
                                        {
                                            self.btnTwoWheeler.setImage(UIImage(named: "redioFillBtn"), for: .normal)
                                            self.btnFourWheeler.setImage(UIImage(named: "redioBtn"), for: .normal)
                                        }
                                        else
                                        {
                                            self.btnTwoWheeler.setImage(UIImage(named: "redioBtn"), for: .normal)
                                            self.btnFourWheeler.setImage(UIImage(named: "redioFillBtn"), for: .normal)
                                        }
                                        
                                        let image = dict.value(forKey: "image") as! String
                                        
                                        self.imgVehicle.setImageFromURl(stringImageUrl: image)
                                        
                                    }
                                    
                                    
                                }
                                self.actInd.stopAnimating()
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
    
    @IBAction func btnUpdateClk(_ sender: Any)
    {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddManageVehicleVC") as! AddManageVehicleVC
        
        addVC.isUpdate = "1"
        addVC.strVehicle = strVehicleID
        self.navigationController?.pushViewController(addVC, animated: true)

    }
    
    @IBAction func btnDeleteClk(_ sender: Any)
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
    
    func deleteVehicle()
    {
        actInd.startAnimating()
        
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=delete_vehicles_user&user_id=\(userID)&vehicle_id=\(strVehicleID)")!
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
                            let msg1:String = resJson.value(forKey:  "RESPONSE") as! String
                            
                            message = "\(msg1)"
                            
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
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageVehicleVC") as! ManageVehicleVC
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
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
