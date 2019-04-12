//
//  FuelModelVarientVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 28/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class FuelModelVarientVC: UIViewController {

    var barTitle: String = ""
    var selectFule = [responseArrayFuel]()
    var strFuleID:String = ""
    
    var selectModel = [responseArrayModel]()
    var strModelID:String = ""
    
    var selectVarient = [responseArrayVarient]()
    var strVarientID:String = ""
    
    @IBOutlet var varientView: UIView!
    @IBOutlet var modelView: UIView!
    @IBOutlet var fuelView: UIView!
    @IBOutlet var lblVarient: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblFuel: UILabel!
    
    
    var fuelTableView = UITableView()
    var modelTableView = UITableView()
    var varientTableView = UITableView()
    
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
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(FuelModelVarientVC.didTapBackButton(sender:)))
        
        let settingBtn = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(FuelModelVarientVC.didTapSettingButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = barTitle
        self.navigationItem.rightBarButtonItem = settingBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        fuelTableView.isHidden = true
        modelTableView.isHidden = true
        varientTableView.isHidden = true
        
        fuelTableView.delegate = self
        fuelTableView.dataSource = self
        
        modelTableView.delegate = self
        modelTableView.dataSource = self
        
        varientTableView.delegate = self
        varientTableView.dataSource = self
        
        
        fuelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        varientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        modelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if currentReachabilityStatus != .notReachable
        {
//            loginCheck(isActive: "")
            fuleType()
        }
        else
        {
            alert()
        }
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    func didTapSettingButton(sender: AnyObject){
        
        print("Setting btn tapped")
    }
    
//    func loginCheck(isActive:String)  {
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
//                        if isActive == "1"
//                        {
//                            self.modelType()
//                        }
//                        else if isActive == "2"
//                        {
//                            self.varientType()
//                        }
//                        else
//                        {
//                            self.fuleType()
//                        }
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

    
    @IBAction func btnFuelClk(_ sender: Any)
    {
        if (fuelTableView.isHidden == true ) {
            fuelTableView.isHidden = false
            fuelTableView.frame = CGRect(x: self.fuelView.frame.origin.x , y:  self.fuelView.frame.origin.y + self.fuelView.frame.size.height, width: self.fuelView.frame.size.width, height: 180)
            fuelTableView.estimatedRowHeight = 60
            self.view.addSubview(fuelTableView)
        }
        else
        {
            fuelTableView.isHidden = true
        }
    }
    
    func fuleType()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_fuel_type&vehicle_type=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectFule.removeAll()
                    
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
                                    
                                    guard let fuel_type = arrData["fuel_type"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["fuel_id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayFuel(fuelType:fuel_type, fuelID:id!)
                                    
                                    self.selectFule.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.fuelTableView.reloadData()
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
    
    
    @IBAction func btnModelClk(_ sender: Any)
    {
        if lblFuel.text == "Fuel"
        {
            alerttxt()
        }
        else
        {
            if (modelTableView.isHidden == true ) {
                modelTableView.isHidden = false
                modelTableView.frame = CGRect(x: self.modelView.frame.origin.x , y:  self.modelView.frame.origin.y + self.modelView.frame.size.height, width: self.modelView.frame.size.width, height: 280)
                fuelTableView.estimatedRowHeight = 60
                self.view.addSubview(modelTableView)
            }
            else
            {
                modelTableView.isHidden = true
            }
        }
    }
    
    func modelType()
    {
        actInd.startAnimating()
        let strBrandID:String = UserDefaults.standard.value(forKey: "BrandIDService") as! String
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_model_for_service&brand_id=\(strBrandID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectModel.removeAll()
                    
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
                                    
                                    guard let model_name = arrData["model_name"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["model_id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayModel(modelName:model_name, modelID:id!)
                                    
                                    self.selectModel.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.modelTableView.reloadData()
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
    
    
    @IBAction func btnVarientClk(_ sender: Any)
    {
        if lblModel.text == "Model"
        {
            alerttxt()
        }
        else
        {
            if (varientTableView.isHidden == true ) {
                varientTableView.isHidden = false
                varientTableView.frame = CGRect(x: self.varientView.frame.origin.x , y:  self.varientView.frame.origin.y + self.varientView.frame.size.height, width: self.varientView.frame.size.width, height: 200)
                fuelTableView.estimatedRowHeight = 60
                self.view.addSubview(varientTableView)
            }
            else
            {
                varientTableView.isHidden = true
            }
        }
    }
    
    func varientType()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_varient_for_service&model_id=\(strModelID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectVarient.removeAll()
                    
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
                                    
                                    guard let varient_name = arrData["varient_name"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["varient_id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayVarient(varientName:varient_name, varientID:id!)
                                    
                                    self.selectVarient.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.modelTableView.reloadData()
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
    
    
    @IBAction func btnNextClk(_ sender: Any)
    {
        if lblModel.text == "Model"
        {
           alerttxt()
        }
        else
        {
            let repairVC = self.storyboard?.instantiateViewController(withIdentifier: "RepairAndDescribeVC") as? RepairAndDescribeVC
            repairVC?.barTitle = self.barTitle
            self.navigationController?.pushViewController(repairVC!, animated: true)
        }
    }
    
  
}

extension FuelModelVarientVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == fuelTableView {
            return selectFule.count
        } else if tableView == varientTableView {
            return selectVarient.count
        } else {
            return selectModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == fuelTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectFule[indexPath.row].fuelType
            return cell
        }
        else if tableView == varientTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectVarient[indexPath.row].varientName
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectModel[indexPath.row].modelName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == varientTableView {
            tableView.cellForRow(at: indexPath)
            lblVarient.text = selectVarient[indexPath.row].varientName
            
            strVarientID = selectVarient[indexPath.row].varientID!
            
            UserDefaults.standard.set(strVarientID, forKey: "varientIDService")
            
            varientTableView.isHidden = true
        }
        else if tableView == fuelTableView {
            tableView.cellForRow(at: indexPath)
            lblFuel.text = selectFule[indexPath.row].fuelType
            strFuleID = selectFule[indexPath.row].fuelID!
            
            UserDefaults.standard.set(strFuleID, forKey: "fuleIDService")
            
            if currentReachabilityStatus != .notReachable
            {
                
//                loginCheck(isActive:"1")
                modelType()
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

            
            fuelTableView.isHidden = true
        }
        else {
            lblModel.text = selectModel[indexPath.row].modelName
            
            strModelID = selectModel[indexPath.row].modelID!
            
            UserDefaults.standard.set(strModelID, forKey: "modelIDService")
            
            if currentReachabilityStatus != .notReachable
            {
                
//                loginCheck(isActive:"2")
                varientType()
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

    
            modelTableView.isHidden = true
            
            
        }
    }
    
}
