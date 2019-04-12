//
//  AddServiceVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 31/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class AddServiceVC: UIViewController {

    @IBOutlet var frontView: UIView!
    
    var selectVehicle = [responseArray]()
    
    var selectServiceStation = [responseServiceArray]()
    
    var strSelectVehicle:String = ""
    var strSelectServiceStation:String = ""

    
    var selectVehicleTableView = UITableView()
    var selectServiceStationTableView = UITableView()
    
    @IBOutlet var viewSelectVehicle: UIView!
    @IBOutlet var viewSelectBrandStation: UIView!
    @IBOutlet var viewServiceDate: UIView!
    @IBOutlet var viewNextServiceDate: UIView!
    @IBOutlet var lblSelectVehicle: UILabel!
    @IBOutlet var lblSelectBrandStation: UILabel!
    @IBOutlet var lblServiceDate: UILabel!
    @IBOutlet var lblNextServiceDate: UILabel!
    @IBOutlet var btnSubmit: UIButton!
    
    // Create a DatePicker
    let datePicker: UIDatePicker = UIDatePicker()
    
    // Create a DatePicker
    let datePickerNext: UIDatePicker = UIDatePicker()
    
    var actInd = UIActivityIndicatorView()
    
    var isActive:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        if currentReachabilityStatus != .notReachable
        {
            self.loginCheck()
//            userVehicle()
//        
//            serviceStation()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AddServiceVC.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.frontView.addSubview(datePicker)
        
        datePicker.isHidden = true
        
        
        
        // Set some of UIDatePicker properties
        datePickerNext.timeZone = NSTimeZone.local
        datePickerNext.backgroundColor = UIColor.white
        datePickerNext.datePickerMode = UIDatePickerMode.date
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePickerNext.addTarget(self, action: #selector(AddServiceVC.datePickerValueChangedNext(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.frontView.addSubview(datePickerNext)
        
        datePickerNext.isHidden = true
        
    }
    
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
       
        // Set date format
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        lblServiceDate.text = selectedDate
        
        datePicker.isHidden = true
    }
    
    
    func datePickerValueChangedNext(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        
        // Set date format
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        lblNextServiceDate.text = selectedDate
        
        datePickerNext.isHidden = true
    }


    override func viewWillAppear(_ animated: Bool) {
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(AddServiceVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Add Service"
        self.navigationItem.leftBarButtonItem = backBtn
        
        selectVehicleTableView.isHidden = true
        selectServiceStationTableView.isHidden = true
        
        selectVehicleTableView.delegate = self
        selectVehicleTableView.dataSource = self
        
        selectServiceStationTableView.delegate = self
        selectServiceStationTableView.dataSource = self
        
        
        selectVehicleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        selectServiceStationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
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
                        
                        if self.isActive == "1"
                        {
                            self.addService()
                        }
                        else
                        {
                            self.userVehicle()
                            
                            self.serviceStation()

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

    
    @IBAction func btnselectServiceStationClk(_ sender: Any)
    {
        datePickerNext.isHidden = true
        datePicker.isHidden = true
        selectVehicleTableView.isHidden = true
        
        if (selectServiceStationTableView.isHidden == true )
        {
            selectServiceStationTableView.isHidden = false
//            selectServiceStationTableView.frame = CGRect(x: self.viewSelectBrandStation.frame.origin.x , y:  self.viewSelectBrandStation.frame.origin.y + 110, width: self.viewSelectBrandStation.frame.size.width + 15, height: 180)
            
            selectServiceStationTableView.frame = CGRect(x: self.viewSelectBrandStation.frame.origin.x , y:  self.viewSelectBrandStation.frame.origin.y + viewSelectBrandStation.frame.size.height, width: self.viewSelectBrandStation.frame.size.width, height: 180)
            selectServiceStationTableView.estimatedRowHeight = 60
            self.frontView.addSubview(selectServiceStationTableView)
        }
        else
        {
            selectServiceStationTableView.isHidden = true
        }
    }
    
    @IBAction func btnselectVehicleClk(_ sender: Any)
    {
        datePickerNext.isHidden = true
        datePicker.isHidden = true
        selectServiceStationTableView.isHidden = true
        
        if (selectVehicleTableView.isHidden == true )
        {
            selectVehicleTableView.isHidden = false
//            selectVehicleTableView.frame = CGRect(x: self.viewSelectVehicle.frame.origin.x , y:  self.viewSelectVehicle.frame.origin.y + 110, width: self.viewSelectVehicle.frame.size.width + 15, height: 200)
            
            selectVehicleTableView.frame = CGRect(x: self.viewSelectVehicle.frame.origin.x , y:  self.viewSelectVehicle.frame.origin.y + self.viewSelectVehicle.frame.size.height, width: self.viewSelectVehicle.frame.size.width, height: 200)
            selectVehicleTableView.estimatedRowHeight = 60
            self.frontView.addSubview(selectVehicleTableView)
            
            
        }
        else
        {
            selectVehicleTableView.isHidden = true
        }
    }
    
    func userVehicle()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//                let userID:String = "62"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_user_vehicle_user&user_id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
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
                                    
                                    guard let name = arrData["brand_name"] as? String else {
                                        return
                                    }
                                    let id = arrData["vehicle_id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArray(brandName: name, vehicleID: id!)
                                
                                    self.selectVehicle.append(r)
                                }
                                DispatchQueue.main.async(execute: { 
                                    self.selectVehicleTableView.reloadData()
                                    
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
    
    
    
    func serviceStation()
    {
       actInd.startAnimating()
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_service_station_user")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectServiceStation.removeAll()
                    
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
                                    
                                    guard let name = arrData["service_station_name"] as? String else {
                                        return
                                    }
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseServiceArray(service_station_name: name, id: id!)
                                    
                                    self.selectServiceStation.append(r)
                                }
                                DispatchQueue.main.async(execute: {
                                    self.selectServiceStationTableView.reloadData()
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

    
    @IBAction func btnServiceDateClk(_ sender: Any)
    {
        datePickerNext.isHidden = true
        selectServiceStationTableView.isHidden = true
        selectVehicleTableView.isHidden = true
        
        if (datePicker.isHidden == true )
        {
            // Posiiton date picket within a view
            datePicker.frame = CGRect(x: viewServiceDate.frame.origin.x, y: viewServiceDate.frame.origin.y + viewServiceDate.frame.size.height, width: viewServiceDate.frame.size.width, height: 200)
            
           datePicker.isHidden = false
            
        }
        else
        {
            datePicker.isHidden = true
        }
    }
    
    @IBAction func btnNextServiceDateClk(_ sender: Any)
    {
        datePicker.isHidden = true
        selectServiceStationTableView.isHidden = true
        selectVehicleTableView.isHidden = true
        
        if (datePickerNext.isHidden == true )
        {
            // Posiiton date picket within a view
            datePickerNext.frame = CGRect(x: viewNextServiceDate.frame.origin.x, y: viewNextServiceDate.frame.origin.y + viewNextServiceDate.frame.size.height, width: viewNextServiceDate.frame.size.width, height: 200)
            
            datePickerNext.isHidden = false
            
        }
        else
        {
            datePickerNext.isHidden = true
        }

    }
    @IBAction func btnSubmitClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            validation()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

        
    }
    
    func validation ()
    {
       if lblSelectVehicle.text! == "Select Vehicle"
       {
            let alert = UIAlertController(title: "Tuseva", message: "Please select vehicle", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lblSelectBrandStation.text! == "Select Brand Station"
       {
            let alert = UIAlertController(title: "Tuseva", message: "Please select service station name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lblServiceDate.text! == "Service Date"
       {
            let alert = UIAlertController(title: "Tuseva", message: "Please select service date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lblNextServiceDate.text! == "Next Service Date"
       {
            let alert = UIAlertController(title: "Tuseva", message: "Please select next service date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
       {
            self.isActive = "1"
            self.loginCheck()
//            addService()
        
        }
        
    }
    
    func addService ()
    {
        actInd.startAnimating()
        let serviceDate:String = lblServiceDate.text!
        let selectNextDate:String = lblNextServiceDate.text!

        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//                let userID:String = "5"
        

        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=add_service_history_user&id=\(userID)&vehicle_id=\(strSelectVehicle)&service_station_name=\(strSelectServiceStation)&service_date=\(serviceDate)&next_service_date=\(selectNextDate)".replacingOccurrences(of: " ", with: "%20")
        
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
    }
    
    func gotoNextVC()
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddServiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == selectServiceStationTableView {
            return selectServiceStation.count
        } else {
            print("ROWS>>\(selectVehicle.count)")
            return selectVehicle.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == selectServiceStationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectServiceStation[indexPath.row].service_station_name
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectVehicle[indexPath.row].brandName
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == selectServiceStationTableView
        {
            tableView.cellForRow(at: indexPath)
            lblSelectBrandStation.text = selectServiceStation[indexPath.row].service_station_name
            
            strSelectServiceStation = selectServiceStation[indexPath.row].id!
            selectServiceStationTableView.isHidden = true
        }
        else
        {
            lblSelectVehicle.text = selectVehicle[indexPath.row].brandName
            strSelectVehicle = selectVehicle[indexPath.row].vehicleID!
            selectVehicleTableView.isHidden = true
        }
    }
    
}

class responseArray {
    var brandName: String?
    var vehicleID: String?
    
    init(brandName:String, vehicleID:String) {
        self.brandName = brandName
        self.vehicleID = vehicleID
    }
}

class responseServiceArray {
    var service_station_name: String?
    var id: String?
    
    init(service_station_name:String, id:String) {
        self.service_station_name = service_station_name
        self.id = id
    }
}

