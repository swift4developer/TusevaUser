

//
//  AddManageVehicleVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 31/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class AddManageVehicleVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var frontView: UIView!
    
    var selectVehicle = [responseArrayVehicle]()
    var selectFuel = [responseArrayFuel]()
    var selectBrand = [responseArrayBrand]()
    var selectModel = [responseArrayModel]()
    var selectVarient = [responseArrayVarient]()
    
    @IBOutlet var btnFourWheeler: UIButton!
    @IBOutlet var btnTwoWheeler: UIButton!
    
    @IBOutlet var imgVehicle: UIImageView!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    var strVehicleID:String = "3"
    var strBrandID:String = ""
    var strModelID:String = ""
    var strFuelID:String = ""
    var strVarientID:String = ""
    
    var fuelTableView = UITableView()
    var modelTableView = UITableView()
    var varientTableView = UITableView()
    var brandTableView = UITableView()
//    var vehicleTableView = UITableView()
    
    @IBOutlet var lblVehicle: UILabel!
    @IBOutlet var viewVehicle: UIView!
    @IBOutlet var viewFuel: UIView!
    @IBOutlet var viewBrand: UIView!
    @IBOutlet var viewVarient: UIView!
    @IBOutlet var viewModelName: UIView!
    @IBOutlet var lblFuel: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblVarient: UILabel!
    @IBOutlet var lblModelName: UILabel!
    @IBOutlet var btnSave: UIButton!
    
    var strIsPlus:String = ""
    var strVehicle:String = ""
    
    var isImage:String = ""
    
    let picker = UIImagePickerController()
    var actInd = UIActivityIndicatorView()
    
    var isActive:String = ""
    
    var isUpdate:String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(AddManageVehicleVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        if isUpdate == "1"
        {
           self.navigationItem.title = "Update Vehicle"
        }
        else
        {
            self.navigationItem.title = "Add Manage Vehicle"
        }
        self.navigationItem.leftBarButtonItem = backBtn
        
        fuelTableView.isHidden = true
        modelTableView.isHidden = true
        brandTableView.isHidden = true
//        vehicleTableView.isHidden = true
        
        fuelTableView.delegate = self
        fuelTableView.dataSource = self
        
//        vehicleTableView.delegate = self
//        vehicleTableView.dataSource = self
        
        modelTableView.delegate = self
        modelTableView.dataSource = self
        
        varientTableView.isHidden = true
        
        varientTableView.delegate = self
        varientTableView.dataSource = self
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        
        fuelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        varientTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        modelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        brandTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        vehicleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
//        if currentReachabilityStatus != .notReachable
//        {
//            Vehicle()
//        }
//        else
//        {
//            print("Internet connection FAILED")
//            
//            alert()
//            
//        }
        
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck()
//            if strIsPlus == "0"
//            {
//                vehicleDetail()
//            }
//            self.fuel()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
        imgVehicle.layer.cornerRadius = imgVehicle.frame.size.height / 2
        imgVehicle.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgVehicle.isUserInteractionEnabled = true
        imgVehicle.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Gallary", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
//            self.picker.popoverPresentationController?.barButtonItem = tapGestureRecognizer as? UIBarButtonItem
            
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
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        self.isImage = "1"
        imgVehicle.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        
//        myImageUploadRequest()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func btnVehicleClk(_ sender: Any)
//    {
//        if (vehicleTableView.isHidden == true)
//        {
//            lblFuel.text = "Fuel Type"
//            lblBrand.text = "Brand"
//            lblModelName.text = "Model Name"
//            lblVarient.text = "Varient"
//            
//            self.vehicleTableView.isHidden = false
//
//            vehicleTableView.frame = CGRect(x: self.viewVehicle.frame.origin.x , y:  self.viewVehicle.frame.origin.y + self.viewVehicle.frame.size.height, width: self.viewVehicle.frame.size.width, height: 120)
//            
//            vehicleTableView.estimatedRowHeight = 60
//            self.frontView.addSubview(vehicleTableView)
//        }
//        else
//        {
//            vehicleTableView.isHidden = true
//        }
//    }
    
    
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
                            self.brandType()
                        }
                        else if self.isActive == "2"
                        {
                            self.modelType()
                        }
                        else if self.isActive == "3"
                        {
                            self.varientType()
                        }
                        else if self.isActive == "4"
                        {
                            self.saveAddManageVehicle()

                        }
                        else
                        {
                            if self.strIsPlus == "0"
                            {
                                self.vehicleDetail()
                            }
                            self.fuel()
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
    
    @IBAction func btnTwoWheelerClk(_ sender: Any)
    {
        strVehicleID = "3"
        btnTwoWheeler.setImage(UIImage(named: "redioFillBtn"), for: UIControlState.normal)
        btnFourWheeler.setImage(UIImage(named: "redioBtn"), for: UIControlState.normal)

    }
    
    @IBAction func btnFourWheelerClk(_ sender: Any)
    {
        strVehicleID = "4"
        btnTwoWheeler.setImage(UIImage(named: "redioBtn"), for: UIControlState.normal)
        btnFourWheeler.setImage(UIImage(named: "redioFillBtn"), for: UIControlState.normal)

    }
    
    
    func vehicleDetail()
    {
        actInd.startAnimating()
        
        let userID = UserDefaults.standard.value(forKey: "ID")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=users_vehicle_detail&user_id=\(userID!)&vehicle_id=\(strVehicle)".replacingOccurrences(of: " ", with: "%20")
        
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
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
                            {
                                for i in resValue
                                {
                                    if let dict = i as? NSDictionary
                                    {
                                        if (dict.value(forKey: "vehicle") as? String) == "2 Wheeler"
                                        {
                                            self.strVehicleID = "3"
                                            
                                            self.btnTwoWheeler.setImage(UIImage(named: "redioFillBtn"), for: UIControlState.normal)
                                            self.btnFourWheeler.setImage(UIImage(named: "redioBtn"), for: UIControlState.normal)
                                        }
                                        else
                                        {
                                            self.strVehicleID = "4"
                                            self.btnFourWheeler.setImage(UIImage(named: "redioFillBtn"), for: UIControlState.normal)
                                            self.btnTwoWheeler
                                                .setImage(UIImage(named: "redioBtn"), for: UIControlState.normal)
                                        }
                                        
                                        self.lblBrand.text = dict.value(forKey: "brand") as? String
                                        self.lblModelName.text = dict.value(forKey: "model") as? String
                                        self.lblVarient.text = dict.value(forKey: "varient") as? String
                                        
                                        guard let fuel = dict.value(forKey: "fuel") as? String
                                            else
                                        {
                                                return
                                        }
                                        
                                        self.lblFuel.text = fuel
                                        
                                        let imgURL = dict.value(forKey: "image") as? String
                                        self.imgVehicle.setImageFromURl(stringImageUrl: imgURL!)
                                    }
                                    
                                    
                                }
                                
                            }
                            message = "Vehicle added Successful"
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.navigationController?.popViewController(animated: true)
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

    
    
//    func Vehicle()
//    {
//        actInd.startAnimating()
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_vehicle_carDealer".replacingOccurrences(of: " ", with: "%20")
//        
//        let url : URLConvertible = URL(string: newString )!
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            print("RESPONSE>>>>>>\(response)")
//            
//            if response.result.isSuccess
//            {
//                if let resJson = response.result.value as? NSDictionary
//                {
//                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
//                    {
//                        var message : String?
//                        if responseCode == 0
//                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                self.actInd.stopAnimating()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        else if responseCode == 1
//                        {
//                            self.selectVehicle.removeAll()
//                            
//                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
//                            {
//                                
//                                for arrData in resValue {
//                                    
//                                    guard let vehicle_type = arrData["vehicle_type"] as? String
//                                    else
//                                    {
//                                        return
//                                    }
//                                    let id = arrData["vehicleid"] as? String
//                                    print("ID>>>\(id!)")
//                                    let r = responseArrayVehicle(vehicleType:vehicle_type, vehicleID:id!)
//
//                                    self.selectVehicle.append(r)
//                                }
//                                
//                                DispatchQueue.main.async(execute: {
//                                    self.vehicleTableView.reloadData()
//                                    self.actInd.stopAnimating()
//                                })
//                            }
//                        }
//                    }
//                }
//            }
//            else if response.result.isFailure
//            {
//                print("Response Error")
//                self.actInd.stopAnimating()
//            }
//        }
//    }
    
    @IBAction func btnFuelClk(_ sender: Any)
    {
        if (fuelTableView.isHidden == true )
        {
            lblBrand.text = "Brand"
            lblModelName.text = "Model Name"
            lblVarient.text = "Varient"
            
            fuelTableView.isHidden = false
            //            fuelTableView.frame = CGRect(x: self.viewFuel.frame.origin.x , y:  self.viewFuel.frame.origin.y + 110, width: self.viewFuel.frame.size.width + 15, height: 180)
            
            fuelTableView.frame = CGRect(x: self.viewFuel.frame.origin.x , y:  self.viewFuel.frame.origin.y + self.viewFuel.frame.size.height, width: self.viewFuel.frame.size.width, height: 180)
            
            fuelTableView.estimatedRowHeight = 60
            self.frontView.addSubview(fuelTableView)
        }
        else
        {
            fuelTableView.isHidden = true
        }
    }


    func fuel()
    {
        actInd.startAnimating()
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
    
    
    @IBAction func btnBrandClk(_ sender: Any)
    {
        if lblFuel.text == "Fuel Type"
        {
            alerttxt()
        }
        else
        {
            if (brandTableView.isHidden == true )
            {
                lblModelName.text = "Model Name"
                lblVarient.text = "Varient"
                
                brandTableView.isHidden = false
                //            brandTableView.frame = CGRect(x: self.viewBrand.frame.origin.x , y:  self.viewBrand.frame.origin.y + 110, width: self.viewBrand.frame.size.width + 15, height: 200)
                
                brandTableView.frame = CGRect(x: self.viewBrand.frame.origin.x , y:  self.viewBrand.frame.origin.y + self.viewBrand.frame.size.height, width: self.viewBrand.frame.size.width, height: 200)
                
                brandTableView.estimatedRowHeight = 60
                self.frontView.addSubview(brandTableView)
            }
            else
            {
                brandTableView.isHidden = true
            }
        }
    }
    
    func brandType()
    {
        actInd.startAnimating()
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
    
    @IBAction func btnModelClk(_ sender: Any)
    {
        if lblBrand.text == "Brand"
        {
            alerttxt()
        }
        else
        {
            if (modelTableView.isHidden == true )
            {
                lblVarient.text = "Varient"
                
                modelTableView.isHidden = false
                //            modelTableView.frame = CGRect(x: self.viewModelName.frame.origin.x , y:  self.viewModelName.frame.origin.y + 110, width: self.viewModelName.frame.size.width + 15 , height: 280)
                
                modelTableView.frame = CGRect(x: self.viewModelName.frame.origin.x , y:  self.viewModelName.frame.origin.y + self.viewModelName.frame.size.height, width: self.viewModelName.frame.size.width, height: 140)
                
                modelTableView.estimatedRowHeight = 60
                self.frontView.addSubview(modelTableView)
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
        if lblModelName.text == "Model Name"
        {
            alerttxt()
        }
        else
        {
            if (varientTableView.isHidden == true ) {
                varientTableView.isHidden = false
    //            varientTableView.frame = CGRect(x: self.viewVarient.frame.origin.x , y:  self.viewVarient.frame.origin.y + 110, width: self.viewVarient.frame.size.width + 15, height: 200)
                
                varientTableView.frame = CGRect(x: self.viewVarient.frame.origin.x , y:  self.viewVarient.frame.origin.y + self.viewVarient.frame.size.height, width: self.viewVarient.frame.size.width, height: 70)

                varientTableView.estimatedRowHeight = 60
                self.frontView.addSubview(varientTableView)
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
    
    
    @IBAction func btnSaveClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            self.isActive = "4"
            self.loginCheck()
//            saveAddManageVehicle()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    
//    func saveAddManageVehicle()
//    {
//        actInd.startAnimating()
//        
//        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
//
////        let userID:String = "62"
//
//        var url: URLConvertible
//        if isUpdate == "1"
//        {
//            url = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=update_vehicles_user&user_id=\(userID)&vehicle_id=\(strVehicle)&vehicle_type=\(strVehicleID)&brand=\(strBrandID)&model=\(strModelID)&varient=\(strVarientID)&fuel=\(strFuelID)")!
//        }
//        else
//        {
//            url  = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=add_vehicles_user&user_id=\(userID)&vehicle_type=\(strVehicleID)&brand=\(strBrandID)&model=\(strModelID)&varient=\(strVarientID)&fuel=\(strFuelID)")!
//        }
//        
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            print("RESPONSE>>>>>>\(response)")
//            
//            if response.result.isSuccess
//            {
//                if let resJson = response.result.value as? NSDictionary
//                {
//                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
//                    {
//                        var message : String?
//                        if responseCode == 0
//                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                                self.actInd.stopAnimating()
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                        else if responseCode == 1
//                        {
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                                self.gotoNextVC()
//                                self.actInd.stopAnimating()
//                                
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                        
//                    }
//                }
//            }
//            else if response.result.isFailure
//            {
//                print("Response Error")
//                self.actInd.stopAnimating()
//            }
//        }
//    }
    
    
    func saveAddManageVehicle()
    {
        actInd.startAnimating()
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
//        let vehicleID = strVehicle
//        let vehicleType = strVehicleID
//        let brandID = strBrandID
//        let modelID = strModelID
//        let fuleID = strFuelID
//        let varientID = strVarientID

        
        var parameters = [String:String]()
        
        if isUpdate == "1"
        {
            parameters = ["user_id":"\(userID)",
                "vehicle_id":"\(strVehicle)",
                "vehicle_type":"\(strVehicleID)",
                "brand":"\(strBrandID)",
                "model":"\(strModelID)",
                "varient":"\(strVarientID)",
                "fuel":"\(strFuelID)"
             ]
        }
        else
        {
            parameters = ["user_id":"\(userID)",
                "vehicle_type":"\(strVehicleID)",
                "brand":"\(strBrandID)",
                "model":"\(strModelID)",
                "varient":"\(strVarientID)",
                "fuel":"\(strFuelID)"
            ]
        }
        
        
        var url:String = ""
        if isUpdate == "1"
        {
            url = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=update_vehicles_user"
        }
        else
        {
            url  = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=add_vehicles_user"        
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.isImage == "1"
            {
                let imageData = UIImageJPEGRepresentation(self.imgVehicle.image!, 0.5)
                
                multipartFormData.append(imageData!, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
            }
            else
            {
                print("none")
            }
            
            
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //                    //self.removeImage("frame", fileExtension: "txt")
                    //                    if let JSON = response.result.value {
                    //                        print("JSON: \(JSON)")
                    //
                    //                        self.actInd.stopAnimating()
                    
                    
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
                
                //                    }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                self.actInd.stopAnimating()
            }
            
        }
    }
    
    func gotoNextVC()
    {
        let serviceHistVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageVehicleVC") as! ManageVehicleVC
        self.navigationController?.pushViewController(serviceHistVC, animated: true)
    }


}

extension AddManageVehicleVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if tableView == vehicleTableView
//        {
//            return selectVehicle.count
//        }
        if tableView == fuelTableView {
            return selectFuel.count
        } else if tableView == varientTableView {
            return selectVarient.count
        } else if tableView == brandTableView {
            return selectBrand.count
        } else {
            return selectModel.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        if tableView == vehicleTableView {
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = selectVehicle[indexPath.row].vehicleType
//            return cell
//        }
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
        else if tableView == brandTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectBrand[indexPath.row].brandType
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectModel[indexPath.row].modelName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == vehicleTableView {
//            tableView.cellForRow(at: indexPath)
//            lblVehicle.text = selectVehicle[indexPath.row].vehicleType
//            
//            strVehicleID = selectVehicle[indexPath.row].vehicleID!
        
//            if currentReachabilityStatus != .notReachable
//            {
//                self.fuel()
//            }
//            else
//            {
//                print("Internet connection FAILED")
//                
//                alert()
//                
//            }
//
//        }
         if tableView == fuelTableView {
            tableView.cellForRow(at: indexPath)
            lblFuel.text = selectFuel[indexPath.row].fuelType
            
            strFuelID = selectFuel[indexPath.row].fuelID!
            
            if currentReachabilityStatus != .notReachable
            {
                isActive = "1"
                loginCheck()
                
//                brandType()
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

            fuelTableView.isHidden = true
        }
        else if tableView == brandTableView {
            tableView.cellForRow(at: indexPath)
            lblBrand.text = selectBrand[indexPath.row].brandType
            
            strBrandID = selectBrand[indexPath.row].brandID!
            
            if currentReachabilityStatus != .notReachable
            {
                isActive = "2"
                loginCheck()
//                modelType()
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

            brandTableView.isHidden = true
        }
        else if tableView == modelTableView  {
            lblModelName.text = selectModel[indexPath.row].modelName
            
            strModelID = selectModel[indexPath.row].modelID!
            
            if currentReachabilityStatus != .notReachable
            {
                self.isActive = "3"
                self.loginCheck()
//                varientType()
            }
            else
            {
                print("Internet connection FAILED")
                
                alert()
                
            }

            modelTableView.isHidden = true
        }
        else {
            tableView.cellForRow(at: indexPath)
            lblVarient.text = selectVarient[indexPath.row].varientName
            
            strVarientID = selectVarient[indexPath.row].varientID!
            varientTableView.isHidden = true
        }
    }
    
}

class responseArrayVehicle {
    var vehicleType: String?
    var vehicleID: String?
    
    init(vehicleType:String, vehicleID:String) {
        self.vehicleType = vehicleType
        self.vehicleID = vehicleID
    }
}

class responseArrayFuel {
    var fuelType: String?
    var fuelID: String?
    
    init(fuelType:String, fuelID:String) {
        self.fuelType = fuelType
        self.fuelID = fuelID
    }
}

class responseArrayBrand {
    var brandType: String?
    var brandID: String?
    var image : String?
    
    init(brandType:String, brandID:String, image:String)
    {
        self.brandID = brandID
        self.brandType = brandType
        self.image = image
    }
}

class responseArrayModel {
    var modelName:String?
    var modelID: String?
    
    init(modelName:String, modelID:String)
    {
        self.modelName = modelName
        self.modelID = modelID
    }
}

class responseArrayVarient {
    var varientName: String?
    var varientID: String?
    
    init(varientName:String, varientID:String) {
        self.varientName = varientName
        self.varientID = varientID
    }
    
}

extension UIViewController
{
    func alerttxt()
    {
        let alert = UIAlertController(title: "Tuseva", message: "Please fill above fields first", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

