//
//  RateVehicleDealerViewController.swift
//  Tuseva
//
//  Created by oms183 on 9/20/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class RateVehicleDealerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var btnCancle: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var frontView: UIView!
    @IBOutlet var lblVehicle: UILabel!
    
    @IBOutlet var lblSelectVehicle: UILabel!
    @IBOutlet var viewVehicle: UIView!
    
    @IBOutlet var btnSelectVehicle: UIButton!
    
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var txtReview: UITextView!
    
    @IBOutlet var lblRate: UILabel!
    
    @IBOutlet var lblReviewValue: UILabel!
    @IBOutlet var btnReview: UIButton!
    
    @IBOutlet var btnStar1: UIButton!
    @IBOutlet var btnStar2: UIButton!
    @IBOutlet var btnStar3: UIButton!
    @IBOutlet var btnStar4: UIButton!
    @IBOutlet var btnStar5: UIButton!
    
    var selectVehicleTableView = UITableView()
    
    var strQueryID:String = "0"
    
    var str1 : Int = 0
    var str2 : Int = 0
    var str3 : Int = 0
    var str4 : Int = 0
    var str5 : Int = 0
    
    var strRate: String = ""
    var strVehicleID: String = ""
    var strBrandID:String = ""
    
    var selectVehicleSP = [responseArrayVehicleDealer]()
    var strSelectID:String = ""
    
    var actInd = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBar(textField: txtReview)
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        txtReview.layer.borderColor = UIColor.gray.cgColor
        txtReview.layer.borderWidth = 1
        txtReview.layer.cornerRadius = 2
        txtReview.delegate = self as UITextViewDelegate
        
        txtReview.text = "Enter your review.."
        
        lblReviewValue.text = ""
        
        selectVehicleTableView.delegate = self
        selectVehicleTableView.dataSource = self
        
        selectVehicleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        selectVehicleTableView.frame = CGRect(x: self.viewVehicle.frame.origin.x , y:  self.viewVehicle.frame.origin.y + viewVehicle.frame.size.height, width: self.viewVehicle.frame.size.width, height: 180)
        selectVehicleTableView.estimatedRowHeight = 60
        self.frontView.addSubview(selectVehicleTableView)
        
        selectVehicleTableView.isHidden = true
        
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(RateVehicleDealerViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Rate Us"
        self.navigationItem.leftBarButtonItem = backBtn
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            selectVehicle()
        }
        else
        {
            alert()
        }
    }
    
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelectVehicleClk(_ sender: Any)
    {
        if selectVehicleTableView.isHidden == true
        {
            selectVehicleTableView.isHidden = false
        }
        else
        {
            selectVehicleTableView.isHidden = true
        }
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
                            self.closeQuery()
                        }
                        else
                        {
                            self.selectVehicle()
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

    
    func selectVehicle()
    {
        actInd.startAnimating()
        
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_service_station_acordingtovehicle&vehicle_id=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_service_station_acordingtovehicle&vehicle_id=\(strVehicleID)&brand_id=\(strBrandID)&query_id=\(strQueryID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectVehicleSP.removeAll()
                    
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
                                    let r = responseArrayVehicleDealer(id: id!, spName: name)
                                    
                                    self.selectVehicleSP.append(r)
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
        return selectVehicleSP.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selectVehicleSP[indexPath.row].spName
            return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            tableView.cellForRow(at: indexPath)
            lblSelectVehicle.text = selectVehicleSP[indexPath.row].spName
            
            self.strSelectID = selectVehicleSP[indexPath.row].id!
            selectVehicleTableView.isHidden = true
        
    }

    
    @IBAction func btnStarClk(_ sender: UIButton)
    {
        let btn: UIButton = sender
        switch btn.tag
        {
        case 1:
            
            if str1 == 0
            {
                btnStar1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str1 = 1
                
                strRate = "1"
                
                lblReviewValue.text = "Really Bad"
            }
            else
            {
                unFill()
                str1 = 0
            }
            break
        case 2:
            
            if str2 == 0
            {
                btnStar1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str2 = 1
                strRate = "2"
                
                lblReviewValue.text = "Bad"
            }
            else
            {
                unFill()
                str2 = 0
            }

            break
        case 3:
            
            if str3 == 0
            {
                btnStar1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str3 = 1
                
                strRate = "3"
                
                lblReviewValue.text = "Fair"
            }
            else
            {
                unFill()
                str3 = 0
            }

            break
        case 4:
            
            if str4 == 0
            {
                btnStar1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str4 = 1
                strRate = "4"
                
                lblReviewValue.text = "Good"
            }
            else
            {
                unFill()
                str4 = 0
            }

            break
        case 5:
            
            if str5 == 0
            {
                btnStar1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_filled"), for: .normal)
                str5 = 1
                strRate = "5"
                
                lblReviewValue.text = "Excelent"
            }
            else
            {
                unFill()
                str5 = 0
            }

            break
        default:
            break
        }
    }
    
    func unFill()
    {
        btnStar1.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar2.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
    }

    @IBAction func btnCancelClk(_ sender: Any)
    {
//        let previousVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as! PreviousQueryVC
//        
//        self.navigationController?.pushViewController(previousVC, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReviewClk(_ sender: Any)
    {
        validation()
    }
    
    func validation()
    {
        if lblSelectVehicle.text == "Select Service Provider"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please Select Service Provider", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.actInd.stopAnimating()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtReview.text == "Enter your review.."
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please give your review", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.actInd.stopAnimating()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if strRate == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please rate first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.actInd.stopAnimating()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if currentReachabilityStatus != .notReachable
            {
                loginCheck(isActive: "1")
//               closeQuery()
            }
            else
            {
                alert()
            }
        }
        
    }
    
    func closeQuery()
    {
        actInd.startAnimating()
        
        let userId = UserDefaults.standard.value(forKey: "ID") as? String
        
        let comment = txtReview.text!
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=close_query&user_id=\(userId!)&sp_id=10&query_id=\(strQueryID)&rate=\(strRate)&comment=\(comment)".replacingOccurrences(of: " ", with: "%20")
        
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
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                                
                                self.goToNextVC()
                                
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

    func goToNextVC()
    {
        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(dashVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension RateVehicleDealerViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RateVehicleDealerViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RateVehicleDealerViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtReview.delegate = self
        txtReview.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtReview.text == "Enter your review.."
        {
            txtReview.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtReview.text == ""
        {
            txtReview.text = "Enter your review.."
        }
    }
}

class responseArrayVehicleDealer {
    var id: String?
    var spName: String?
    
    init(id:String, spName:String) {
        self.id = id
        self.spName = spName
    }
}
