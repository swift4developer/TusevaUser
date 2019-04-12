//
//  AddServiceReminderViewController.swift
//  Tuseva
//
//  Created by oms183 on 9/16/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class AddServiceReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var viewVehicle: UIView!    
    @IBOutlet var lblSelectVehicle: UILabel!
    @IBOutlet var btnSelectVehicle: UIButton!
    
    @IBOutlet var viewReminderDate: UIView!
    @IBOutlet var lblReminderDate: UILabel!
    @IBOutlet var btnReminderDate: UIButton!
    
    @IBOutlet var scrollVC: UIView!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet var txtViewDesc: UITextView!
    
    @IBOutlet var btnSubmit: UIButton!
    
    var selectVehicleTableView = UITableView()
    
    var selectVehicle = [responseArrayVehicle]()
    var strVehicleID:String = ""
    
    // Create a DatePicker
    let datePicker: UIDatePicker = UIDatePicker()
    
    var actInd = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        addToolBar(textField: txtViewDesc)
        
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(AddServiceReminderViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Add Service Reminder"
        self.navigationItem.leftBarButtonItem = backBtn
        
        selectVehicleTableView.isHidden = true

        selectVehicleTableView.delegate = self
        selectVehicleTableView.dataSource = self
        
        
        selectVehicleTableView.frame = CGRect(x: self.viewVehicle.frame.origin.x , y:  self.viewVehicle.frame.origin.y + viewVehicle.frame.size.height, width: self.viewVehicle.frame.size.width, height: 180)
        selectVehicleTableView.estimatedRowHeight = 60
        self.scrollVC.addSubview(selectVehicleTableView)
        
        selectVehicleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AddServiceReminderViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.scrollVC.addSubview(datePicker)
        
        datePicker.isHidden = true
        selectVehicleTableView.isHidden = true
        
        
        txtViewDesc.layer.borderWidth = 1
        txtViewDesc.layer.borderColor = UIColor.gray.cgColor
        txtViewDesc.layer.cornerRadius = 2
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            selectVehicleType()
        }
        else
        {
            alert()
        }

    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }

    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        
        // Set date format
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        lblReminderDate.text = selectedDate
        
        datePicker.isHidden = true
    }


    @IBAction func btnSelectVehicleClk(_ sender: Any)
    {
        selectVehicleTableView.isHidden = false
        datePicker.isHidden = true
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
                            self.addServiceReminder()
                        }
                        else
                        {
                            self.selectVehicleType()
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return selectVehicle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectVehicle[indexPath.row].vehicleType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        lblSelectVehicle.text = selectVehicle[indexPath.row].vehicleType
        strVehicleID = selectVehicle[indexPath.row].vehicleID!
        selectVehicleTableView.isHidden = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    
    @IBAction func btnReminderDateClk(_ sender: Any)
    {
        if lblSelectVehicle.text == "Select Vehicle"
        {
            alerttxt()
        }
        else
        {
            selectVehicleTableView.isHidden = true
            if (datePicker.isHidden == true )
            {
                // Posiiton date picket within a view
                datePicker.frame = CGRect(x: viewReminderDate.frame.origin.x, y: viewReminderDate.frame.origin.y + viewReminderDate.frame.size.height, width: viewReminderDate.frame.size.width, height: 200)
                self.scrollVC.addSubview(datePicker)
                
                
                datePicker.isHidden = false
                
            }
            else
            {
                datePicker.isHidden = true
            }
        }
    }
    
    @IBAction func btnSubmitClk(_ sender: Any)
    {
        validation()
    }
    
    func validation ()
    {
        if lblSelectVehicle.text == "Select Vehicle"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please select Vehicle", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lblReminderDate.text == "Select Reminder Date"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please select Reminder Date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtViewDesc.text == "Please Enter Description.."
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Enter Description", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            loginCheck(isActive: "1")
//            addServiceReminder()
        }
    }
    
    func addServiceReminder()
    {
        actInd.startAnimating()
//        let vehicleType:String = lblSelectVehicle.text!
        let reminderDate:String = lblReminderDate.text!
        
        
        let desc:String = txtViewDesc.text!
        
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
        //                let userID:String = "5"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=add_service_reminder&user_id=\(userID)&vehicle_id=\(strVehicleID)&reminder_date=\(reminderDate)&description=\(desc)".replacingOccurrences(of: " ", with: "%20")
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension AddServiceReminderViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddServiceReminderViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddServiceReminderViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtViewDesc.delegate = self
        txtViewDesc.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtViewDesc.text == "Please Enter Description.."
        {
            txtViewDesc.text = ""
        }
        else
        {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtViewDesc.text == ""
        {
            txtViewDesc.text = "Please Enter Description.."
        }
        else
        {
            
        }
    }
    
}

