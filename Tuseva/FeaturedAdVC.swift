//
//  FeaturedAdVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 29/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class FeaturedAdVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrfeaturedPlan = [featuredPlanArray]()
    
    var arrIndex = [String]()

    @IBOutlet var tblView: UITableView!
    
    var repairType: String = ""
    var desc: String = ""
    var strQueryID:String = ""
    var strPlan_id:String = "0"
    
    var isImage:String = ""
    var isVideo:String = ""
    
    var videoURL = NSURL()
    var image:UIImage?
    
    var shareContact:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(FeaturedAdVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Featured Ad"
        self.navigationItem.leftBarButtonItem = backBtn
        
        if currentReachabilityStatus != .notReachable
        {
//            loginCheck(isActive: "")
            featuredAdd()
        }
        else
        {
            alert()
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
                            if self.strPlan_id == "0"
                            {
                                let alert = UIAlertController(title: "Tuseva", message: "Please select plan first", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                self.upload()
                            }
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
    
    func featuredAdd()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=getPlans".replacingOccurrences(of: " ", with: "%20")
        
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
                                self.goToNextVC()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else if responseCode == 1
                        {
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
                            {

                                for arrData in resValue {

                                    guard let description = arrData["description"] as? String
                                        else
                                    {
                                        return
                                    }
                                    
                                    guard let price = arrData["price"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let duration = arrData["duration"] as? String
                                    
                                    let id = arrData["id"] as? String
                                    
                                    let r = featuredPlanArray(id:id!,duration:duration!, price:price, description:description)

                                    self.arrfeaturedPlan.append(r)
                                    self.arrIndex.append("0")
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
            }
        }
    }

   
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnPaymentClk(_ sender: Any)
    {
//        createQuery()
        
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                loginCheck(isActive: "1")
//                upload()
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoLoginVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            alert()
        }
    }
    
    func gotoLoginVC()
    {
        if currentReachabilityStatus != .notReachable
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrfeaturedPlan.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! featuredTableCell
        
        cell.lblPrice.text = arrfeaturedPlan[indexPath.section].price
        cell.lblTitle.text = "Featured Ad for \(arrfeaturedPlan[indexPath.section].duration!)"
        cell.lblSubTitile1.text = arrfeaturedPlan[indexPath.section].description
        
        cell.btnCheck.tag = indexPath.section
        
        cell.btnCheck.addTarget(self,action:#selector(btnCheckClk(sender:)), for: .touchUpInside)
        
        if arrIndex[indexPath.section] == "1"
        {
            cell.btnCheck.setImage(UIImage(named: "checked"), for: UIControlState.normal)
            
            arrIndex[indexPath.section] = "0"
        }
        else
        {
            cell.btnCheck.setImage(UIImage(named: "un_check"), for: UIControlState.normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func btnCheckClk(sender:UIButton)
    {
      
//        let indexPath = IndexPath(row: 0, section: sender.tag)
//        let cell = tblView.cellForRow(at: indexPath) as! featuredTableCell
        
//        if cell.btnCheck.currentImage == UIImage(named: "un_check")
//        {
//            cell.btnCheck.setImage(UIImage(named: "checked"), for: UIControlState.normal)
//        }
//        else
//        {
//            cell.btnCheck.setImage(UIImage(named: "un_check"), for: UIControlState.normal)
//        }
        
        self.arrIndex[sender.tag] = "1"
        
        strPlan_id = arrfeaturedPlan[sender.tag].id!
        
        tblView.reloadData()
    }
    
    
    func upload()
    {
        actInd.startAnimating()
        let userID = UserDefaults.standard.value(forKey: "ID") as! String
        let vehicleID = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        let brandID = UserDefaults.standard.value(forKey: "BrandIDService") as! String
        let modelID = UserDefaults.standard.value(forKey: "modelIDService") as! String
        let fuleID = UserDefaults.standard.value(forKey: "fuleIDService")as! String
        var varientID:String = ""
        if UserDefaults.standard.value(forKey: "varientIDService") != nil
        {
            
            varientID = UserDefaults.standard.value(forKey: "varientIDService") as! String
        }
        else
        {
            varientID = ""
        }
        let repairType = self.repairType
        let desc = self.desc
        let planID = strPlan_id
        let shareCnt = shareContact
        
        var parameters = [String:String]()
        parameters = ["id":"\(userID)",
            "vehicle":"\(vehicleID)",
            "brand":"\(brandID)",
            "model":"\(modelID)",
            "repair_type": "\(repairType)",
            "description":"\(desc)",
            "varient": "\(varientID)",
            "fuel" : "\(fuleID)",
            "plan_id" : "\(planID)",
            "hide_contact_detail" : "\(shareCnt)" ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if self.isImage == "1" && self.isVideo == "1"
            {
                let imageData = UIImageJPEGRepresentation(self.image!, 0.5)
                
                multipartFormData.append(imageData!, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
                multipartFormData.append((self.videoURL as URL), withName: "video")
            }
            else if self.isImage == "1" && self.isVideo != "1"
            {
                let imageData = UIImageJPEGRepresentation(self.image!, 0.5)
                
                multipartFormData.append(imageData!, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
                
            }
            else if self.isImage != "1" && self.isVideo == "1"
            {
                multipartFormData.append((self.videoURL as URL), withName: "video")
            }
            else
            {
                print("none")
            }


            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=create_query_user")
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
                                    let strRepairResponse:Int = resJson.value(forKey:  "RESPONSEID") as! Int
                                    self.strQueryID = "\(strRepairResponse)"
                                    
                                    //                            let otp:Int = resJson.value(forKey:  "otp") as! Int
                                    
                                    //                            self.strOTP = "\(otp)"
                                    //                             self.strOTP = resJson.value(forKey: "otp") as! String
                                    
                                    message = resJson.value(forKey:  "RESPONSE") as? String
                                    
                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                        self.goToNextVC()
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

    
    
//    func createQuery()
//    {
//        actInd.startAnimating()
//        let userID = UserDefaults.standard.value(forKey: "ID") as! String
//        let vehicleID = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
//        let brandID = UserDefaults.standard.value(forKey: "BrandIDService") as! String
//        let modelID = UserDefaults.standard.value(forKey: "modelIDService") as! String
//        
//        let planID = strPlan_id
//
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=create_query_user&id=\(userID)&vehicle=\(vehicleID)&brand=\(brandID)&model=\(modelID)&repair_type=\(repairType)&description=\(desc)&plan_id=\(planID)".replacingOccurrences(of: " ", with: "%20")
//        
//        let url : URLConvertible = URL(string: newString)!
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
//                            let strRepairResponse:Int = resJson.value(forKey:  "RESPONSEID") as! Int
//                            self.strQueryID = "\(strRepairResponse)"
//                            
//                            //                            let otp:Int = resJson.value(forKey:  "otp") as! Int
//                            
//                            //                            self.strOTP = "\(otp)"
//                            //                             self.strOTP = resJson.value(forKey: "otp") as! String
//                            
//                            message = resJson.value(forKey:  "RESPONSE") as? String
//                            
//                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                                self.goToNextVC()
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
    
    func goToNextVC()
    {
        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(dashVC, animated: true)
    }

}

class featuredTableCell: UITableViewCell {

    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var lblSubTitile3: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitile1: UILabel!
    @IBOutlet var lblSubTitile2: UILabel!
    @IBAction func btnCheckClk(_ sender: Any)
    {

    }
}

class featuredPlanArray
{
    var id :String?
    var duration:String?
    var price : String?
    var description:String?
    
    init(id:String,duration:String, price:String, description:String)
    {
        self.id = id
        self.duration = duration
        self.price = price
        self.description = description
    }
}
