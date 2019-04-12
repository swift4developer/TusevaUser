
//
//  FiltersViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 02/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import PinCodeTextField
import Alamofire

class FiltersViewController: UIViewController {
    
       @IBOutlet var txtEnterCode: PinCodeTextField!
        @IBOutlet var childView: UIView!
    
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var rangeSlider: RangeSlider!
    
    @IBOutlet var btnDontShare: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var shareView: UIView!
    var shareContact:String = ""
    
    @IBOutlet var parentView: UIView!
    
    
    var barTitle: String = ""
    
    var selectFuel = [responseArrayFuel]()
    var strFuelID:String = ""
    
    var selectModel = [responseArrayModel]()
    var strModelID:String = ""
    
    var selectVarient = [responseArrayVarient]()
    var strVarientID:String = ""
    
    var selectColor = [responseArrayColor]()
    var strColorID:String = ""
    
    var isCheck:String = "1"
    
    var strOtpBuy:String = ""
    var strQueryIDBuy:String = ""
    
    
    var minRange:String = ""
    var maxRange:String = ""
    
    var min:Int = 0
    var max:Int = 0
    
    @IBOutlet var btnRequest: UIButton!

    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var lblDescTitle: UILabel!
    @IBOutlet var varientView: UIView!
    @IBOutlet var modelView: UIView!
    @IBOutlet var fuelView: UIView!
    @IBOutlet var lblVarient: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblFuel: UILabel!
    @IBOutlet var lblColor: UILabel!
    @IBOutlet var btnRequestClk: UIButton!
    
    @IBOutlet var lblNumberVerify: UILabel!
    
    var fuelTableView = UITableView()
    var modelTableView = UITableView()
    var varientTableView = UITableView()
    var colorTableView = UITableView()
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.parentView.isHidden = true
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(FiltersViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = barTitle
        self.navigationItem.leftBarButtonItem = backBtn
        
        fuelTableView.isHidden = true
        modelTableView.isHidden = true
        varientTableView.isHidden = true
        colorTableView.isHidden = true
        
        fuelTableView.delegate = self
        fuelTableView.dataSource = self
        
        modelTableView.delegate = self
        modelTableView.dataSource = self
        
        varientTableView.delegate = self
        varientTableView.dataSource = self
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        
        fuelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        varientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        modelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        colorTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        rangeSlider.addTarget(self, action: #selector(FiltersViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        
        addToolBar(textField: txtDescription)
        
        let mobileNO:String = UserDefaults.standard.value(forKey: "mobile") as! String
        lblNumberVerify.text = "We sent a code to \(mobileNO) Enter it to verify your number"
        
        hideKeyboardWhenTappedAround()

        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            selectRange()
//            fuleType()
//            colorChange()
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
                            self.modelType()
                        }
                        else if isActive == "2"
                        {
                            self.varientType()
                        }
                            else if isActive == "4"
                        {
                            self.createQueryBuy(shareCnt: "1")
                        }
                            else if isActive == "5"
                        {
                            self.createQueryBuy(shareCnt: "0")
                        }
                        else
                        {
                            self.selectRange()
                            self.fuleType()
                            self.colorChange()
                        
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


    func rangeSliderValueChanged(_ rangeSlider: RangeSlider)
    {
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        
        minRange = "\(rangeSlider.lowerValue)"
        maxRange = "\(rangeSlider.upperValue)"
        
        min = Int(rangeSlider.lowerValue)
        
        max = Int(rangeSlider.upperValue)
        
        lblPrice.text = "₹ \(min) - ₹ \(max)"
    }

    func selectRange()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_vehicle_range&vehicle_id=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectFuel.removeAll()
                    
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
                            self.minRange = resJson.value(forKey:  "min_range") as! String
                            self.maxRange = resJson.value(forKey:  "max_range") as! String
                            
                            self.rangeSlider.maximumValue = Double(self.maxRange)!
                            
                            self.rangeSlider.minimumValue = Double(self.minRange)!
                            
                            self.rangeSlider.upperValue = self.rangeSlider.maximumValue
                            
                            self.rangeSlider.lowerValue = self.rangeSlider.minimumValue
                            
                            self.max = Int(self.rangeSlider.upperValue)
                            
                            self.min = Int(self.rangeSlider.lowerValue)
                            
                            self.lblPrice.text = "₹ \(self.min) - ₹ \(self.max)"
                            
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
    
    @IBAction func btnFuelClk(_ sender: Any) {
        if (fuelTableView.isHidden == true ) {
            fuelTableView.isHidden = false
            fuelTableView.frame = CGRect(x: self.fuelView.frame.origin.x , y:  self.fuelView.frame.origin.y + self.fuelView.frame.size.height + 10, width: self.fuelView.frame.size.width, height: 180)
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
                    self.selectFuel.removeAll()
                    
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
                                    
                                    self.selectFuel.append(r)
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
        if lblFuel.text == "Fuel Type"
        {
            alerttxt()
        }
        else
        {
            if (modelTableView.isHidden == true ) {
                modelTableView.isHidden = false
                modelTableView.frame = CGRect(x: self.modelView.frame.origin.x , y:  self.modelView.frame.origin.y + self.modelView.frame.size.height + 10, width: self.modelView.frame.size.width, height: 280)
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
        let strBrandID:String = UserDefaults.standard.value(forKey: "BrandIDServiceBuy") as! String
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_model_for_buy&brand_id=\(strBrandID)".replacingOccurrences(of: " ", with: "%20")
        
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
        if (varientTableView.isHidden == true ) {
            varientTableView.isHidden = false
            varientTableView.frame = CGRect(x: self.varientView.frame.origin.x , y:  self.varientView.frame.origin.y + self.varientView.frame.size.height + 10, width: self.varientView.frame.size.width, height: 200)
            fuelTableView.estimatedRowHeight = 60
            self.view.addSubview(varientTableView)
        }
        else
        {
            varientTableView.isHidden = true
        }
    }
    
    
    func varientType()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_varient_for_buy&model_id=\(strModelID)".replacingOccurrences(of: " ", with: "%20")
        
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

    
    @IBAction func btnColorClk(_ sender: Any)
    {
//        if lblVarient.text == "Varient"
//        {
//            alerttxt()
//        }
//        else
//        {
            if (colorTableView.isHidden == true ) {
                colorTableView.isHidden = false
                colorTableView.frame = CGRect(x: self.colorView.frame.origin.x , y:  self.colorView.frame.origin.y + self.colorView.frame.size.height + 10, width: self.colorView.frame.size.width, height: 180)
                colorTableView.estimatedRowHeight = 60
                self.view.addSubview(colorTableView)
            }
//            else
//            {
//                fuelTableView.isHidden = true
//            }
//        }
    }
    
    func colorChange()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_color&vehicle_type=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectColor.removeAll()
                    
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
                                    
                                    guard let colorName = arrData["color"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayColor(colorName:colorName, colorID:id!)
                                    
                                    self.selectColor.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.colorTableView.reloadData()
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

    @IBAction func btnRequestClk(_ sender: Any)
    {
        if isCheck == "1"
        {
            btnRequestClk.setImage(UIImage(named:"un_check"), for: UIControlState.normal)
            isCheck = "0"
        }
        else
        {
            btnRequestClk.setImage(UIImage(named:"checked"), for: UIControlState.normal)
            isCheck = "1"
        }
    }
    
    
    @IBAction func btnNextClk(_ sender: Any)
    {
        if lblModel.text == "Model" || txtDescription.text == "Please enter some description.." || txtDescription.text == ""
        {
            alerttxt()
        }
        else
        {
            if currentReachabilityStatus != .notReachable
            {
                shareView.isHidden = false
                parentView.isHidden = true
//                createQueryBuy()
            }
            else
            {
                alert()
            }
        }
        
    }
    
    func createQueryBuy(shareCnt:String)
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        let strBrandID:String = UserDefaults.standard.value(forKey: "BrandIDServiceBuy") as! String
        let userID: String = UserDefaults.standard.value(forKey: "ID") as! String
        let description:String = txtDescription.text!
        
        //        let userID:String = "5"
        
        let maxValue:String = "\(max)"
        let minValue:String = "\(min)"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=create_buy_query_user&id=\(userID)&vehicle=\(strVehicleID)&brand=\(strBrandID)&model=\(strModelID)&varient=\(strVarientID)&color=\(strColorID)&fuel=\(strFuelID)&min_range=\(minValue)&max_range=\(maxValue)&description=\(description)&ride=\(isCheck)&hide_contact_detail=\(shareCnt)".replacingOccurrences(of: " ", with: "%20")
        
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
                            
                            let otp:Int = resJson.value(forKey:  "otp") as! Int
                            
                            self.strOtpBuy = "\(otp)"
                            
                            let responseID = resJson.value(forKey: "RESPONSEID") as! Int
                            self.strQueryIDBuy = "\(responseID)"
                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.gotoNextVC()
                                self.actInd.stopAnimating()
//                                
//                            }))
//                            self.present(alert, animated: true, completion: nil)
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
        shareView.isHidden = true
        if parentView.isHidden == true
        {
            txtEnterCode.text = strOtpBuy
            parentView.isHidden = false
        }
        else
        {
            parentView.isHidden = true
        }
    }
    
    @IBAction func btnVerifyClk(_ sender: Any)
    {
        Validation()
    }
    
    func Validation()
    {
        if txtEnterCode.text == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Otp", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if currentReachabilityStatus != .notReachable
            {
                confirmOtpQuery()
            }
            else
            {
                alert()
            }
        }
    }
   
    
    func confirmOtpQuery()
    {
        actInd.startAnimating()
        let otp:String = txtEnterCode.text!
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=confirm_otp_query&query_id=\(strQueryIDBuy)&otp=\(otp)")!
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
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.gotoNextVC1()
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
    
    func gotoNextVC1()
    {
//        if shareContact == "1"
//        {
//            self.parentView.isHidden = true
//            let popVC = self.storyboard?.instantiateViewController(withIdentifier: "CongratsPopUpVC") as? CongratsPopUpVC
//            
//            var frame: CGRect = popVC!.view.frame;
//            frame.size.width = UIScreen.main.bounds.size.width
//            frame.size.height = UIScreen.main.bounds.size.height
//            popVC?.view.frame = frame;
//            
//            self.addChildViewController(popVC!)
//            self.view.addSubview((popVC?.view)!)
//            popVC?.didMove(toParentViewController: self)
//        }
//        else
//        {
//            let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
//            self.navigationController?.pushViewController(dashVC, animated: true)
//        }
        
        
        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as! PreviousQueryVC
        self.navigationController?.pushViewController(dashVC, animated: true)

    }
    
    @IBAction func btnCancelClk(_ sender: Any) {
        self.parentView.isHidden = true
        
    }
    @IBAction func btnResendClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            resendQueryOtp()
        }
        else
        {
            alert()
        }
        
    }
    
    func resendQueryOtp()
    {
        actInd.startAnimating()
        let mobNO:String = UserDefaults.standard.value(forKey: "mobile") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=resend_otp_query&query_id=\(strQueryIDBuy)&mobile_no=\(mobNO)".replacingOccurrences(of: " ", with: "%20")
        
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
                            //                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            //                            self.txtOtpCode.text = resJson.value(forKey:  "otp") as? String
                            
                            message = "OTP send to your registered mobile number"
                            
                            self.txtEnterCode.text = resJson.value(forKey:  "RESPONSEOTP") as? String
                            
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

    @IBAction func btnShareClk(_ sender: Any)
    {
        shareContact = "1"
        
        loginCheck(isActive: "4")
//        createQueryBuy(shareCnt: "1")
    }

    @IBAction func btnDontShareClk(_ sender: Any)
    {
        shareContact = "0"
        loginCheck(isActive: "5")
//        createQueryBuy(shareCnt: "0")
    }
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == fuelTableView {
            return selectFuel.count
        }
        else if tableView == varientTableView {
            return selectVarient.count
        }
        else if tableView == colorTableView {
            return selectColor.count
        }
        else {
            return selectModel.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == fuelTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectFuel[indexPath.row].fuelType
            return cell
        }
        else if tableView == varientTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectVarient[indexPath.row].varientName
            return cell
        }
        else if tableView == colorTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectColor[indexPath.row].colorName
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
            
            if currentReachabilityStatus != .notReachable
            {
                colorChange()
            }
            else
            {
                alert()
            }
            
            varientTableView.isHidden = true
        }
        else if tableView == fuelTableView {
            tableView.cellForRow(at: indexPath)
            lblFuel.text = selectFuel[indexPath.row].fuelType
            strFuelID = selectFuel[indexPath.row].fuelID!
            
            if currentReachabilityStatus != .notReachable
            {
                loginCheck(isActive: "1")
//               modelType()
            }
            else
            {
                alert()
            }
            fuelTableView.isHidden = true
        }
        else if tableView == colorTableView {
            tableView.cellForRow(at: indexPath)
            lblColor.text = selectColor[indexPath.row].colorName
            strColorID = selectColor[indexPath.row].colorID!
            
            colorTableView.isHidden = true
        }
        else {
            lblModel.text = selectModel[indexPath.row].modelName
            
            strModelID = selectModel[indexPath.row].modelID!
            
            if currentReachabilityStatus != .notReachable
            {
                loginCheck(isActive: "2")
//                varientType()
            }
            else
            {
                alert()
            }
            
            modelTableView.isHidden = true
            
            
        }
    }
    
}

class responseArrayColor
{
    var colorName : String?
    var colorID : String?
    
    init(colorName:String, colorID:String)
    {
        self.colorName = colorName
        self.colorID = colorID
    }
}


extension FiltersViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltersViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FiltersViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtDescription.delegate = self
        txtDescription.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtDescription.text == "Please enter some description.."
        {
            txtDescription.text = ""
        }
        else
        {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtDescription.text == ""
        {
            txtDescription.text = "Please enter some description.."
        }
        else
        {
            
        }
    }
    
}

