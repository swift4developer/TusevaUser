//
//  QueryDetailsVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 03/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class QueryDetailsVC: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblQueryDate: UILabel!
    @IBOutlet var lblVarient: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblFuelType: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnCloseQuery: UIButton!
    
    @IBOutlet var btnPlan: UIButton!
    
    @IBOutlet var imgGarrage: UIImageView!
    var strQureyID: String = ""
    
    var vehicleID:String = ""
    var brandID:String = ""
    
    var planID:String = ""
    var planName:String = ""
    
    var arrOfferServiceList = [responseArrayServiceList]()
    
    var actInd = UIActivityIndicatorView()
    
    var dictResp = NSDictionary()
    
    var selectedUser: String = ""
    
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet var popUpFront: UIView!
    
    
    @IBOutlet var lblPlanName: UILabel!
    
    @IBOutlet var lblPlanValidity: UILabel!
    
    @IBOutlet var lblPlanAmount: UILabel!
    
    @IBOutlet var lblPlanDesc: UILabel!
    
    @IBOutlet var btnOk: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    override func viewWillAppear(_ animated: Bool)
    {
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(QueryDetailsVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Query Details"
        self.navigationItem.leftBarButtonItem = backBtn
        
        popUpFront.layer.cornerRadius = 3
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            queryDetail()
//            serviceProviderList()
        }
        else
        {
            alert()
        }

    }

    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOfferServiceList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! QueryTableCell
        cell.lblRemaning.layer.cornerRadius = 10.0
        cell.lblRemaning.clipsToBounds = true
        
        cell.lblServicePro.text = arrOfferServiceList[indexPath.section].spName
        cell.lblDetailsCell.text = "\(arrOfferServiceList[indexPath.section].spAddress!) \(arrOfferServiceList[indexPath.section].sp_id!)"
        
//        cell.lblDateCell.text = arrOfferServiceList[indexPath.section].offerDate
        cell.lblDateCell.text = ""

//        let imgURL = arrOfferServiceList[indexPath.section].image!
//        cell.imgServiceProvider.setImageFromURl(stringImageUrl: imgURL )
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "QueryDetailViewController") as! QueryDetailViewController
        
        self.selectedUser = arrOfferServiceList[indexPath.section].sp_id!
        detailedVC.strQueryID = strQureyID
        
        detailedVC.dictResponse = dictResp
        
        detailedVC.currentUser = self.selectedUser
        
        self.navigationController?.pushViewController(detailedVC, animated: true)
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
                            self.DeleteQuery()
                        }
                        else if isActive == "2"
                        {
                            self.getPlanDetails()
                        }
                        else
                        {
                            self.queryDetail()
                            self.serviceProviderList()
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

    func queryDetail()
    {
        actInd.startAnimating()
//        let userID = UserDefaults.standard.value(forKey: "ID") as? String
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=query_detail&id=\(strQureyID)")!
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
                                        
                                        self.lblModel.text = dict.value(forKey:"model") as? String
                                        
                                        self.lblBrand.text = dict.value(forKey: "brand") as? String
                                        
                                        self.lblFuelType.text = dict.value(forKey: "fuel") as? String
                                        
                                        self.lblVarient.text = dict.value(forKey: "varient") as? String
                                        
                                        self.lblQueryDate.text = dict.value(forKey: "query_date") as? String
                                        
                                        self.vehicleID = dict.value(forKey: "vehicle_id") as! String
                                        
                                        self.brandID = dict.value(forKey: "brand_id") as! String
                                        
                                        self.planID = dict.value(forKey:"plan_id") as! String
                                        
                                        self.planName = dict.value(forKey: "plan_name") as! String
                                        
                                        let name:String = "Plan Name: \(self.planName)"
                                        
                                        self.btnPlan.setTitle(name, for: UIControlState.normal)
                                        
                                        self.lblDetails.text = dict.value(forKey: "detail_description") as? String
                                        
                                        var image = ""
                                        
                                        if let arrImage = dict.value(forKey:  "image") as? [AnyObject]
                                        {
                                            for arrImgData in arrImage
                                            {
                                                image = (arrImgData["image"] as? String)!
                                                
                                                break
                                            }
                                        }
                                        else
                                        {
                                            image = ""
                                        }
                                        
                                        if self.planID == ""
                                        {
                                            self.btnPlan.isHidden = true
                                        }
                                        else
                                        {
                                            self.btnPlan.isHidden = false
                                        }
                                        
                                        self.imgGarrage.setImageFromURl(stringImageUrl: image)

                                        
                                    }
                                    
                                    
                                }
                                
                                self.dictResp = (resJson.value(forKey:  "RESPONSE") as? NSArray)?.object(at: 0) as! NSDictionary
                                
                                print("resp:\(self.dictResp)")
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
    
    
    func serviceProviderList()
    {
        actInd.startAnimating()
        
        // static value
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=service_provider_list&query_id=\(strQureyID)".replacingOccurrences(of: " ", with: "%20")
        
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_service_providers_query&id=147,62".replacingOccurrences(of: " ", with: "%20")

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
                            self.arrOfferServiceList.removeAll()

                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
                            {

                                for arrData in resValue
                                {
                                    let sp_id = arrData["sp_id"] as? String

                                    let spName = arrData["sp_name"] as? String
                                    let spAddress = arrData["sp_address"] as? String
//                                    let spCity = arrData["city"] as? String
                                    
//                                    let image = arrData["image"] as? String
//                                    let freePickUp = arrData["free_pickup_delivery"] as? String
//                                    let offer = arrData["offer"] as? String

                                    
                                    let r = responseArrayServiceList(sp_id:sp_id!, spName:spName!, spAddress:spAddress!)

                                    self.arrOfferServiceList.append(r)
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
    
    @IBAction func btnCloaseQueryClk(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Tuseva", message: "Was Tuseva helpfull to resolve your problem", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
            self.loginCheck(isActive: "1")
//            self.DeleteQuery()
            
        }))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.nextVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func DeleteQuery()
    {
        actInd.startAnimating()
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=delete_query&query_id=\(strQureyID)".replacingOccurrences(of: " ", with: "%20")
        
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
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                                self.goToBackVC()
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
    
    func goToBackVC()
    {
        let previousVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as! PreviousQueryVC
        
        self.navigationController?.pushViewController(previousVC, animated: true)
    }
    
    @IBAction func btnPlanClk(_ sender: Any)
    {
        self.popUpView.isHidden = false
        
        loginCheck(isActive:"2")
    }
    
    func getPlanDetails()
    {
        actInd.startAnimating()
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=plan_detail&plan_id=\(self.planID)".replacingOccurrences(of: " ", with: "%20")
        
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
                                        self.lblPlanName.text = dict.value(forKey: "plan_name") as? String
                                        
                                        self.lblPlanValidity.text = dict.value(forKey: "plan_validity") as? String
                                        
                                        self.lblPlanAmount.text = dict.value(forKey: "plan_amount") as? String
                                        
                                        self.lblPlanDesc.text = dict.value(forKey: "plan_description") as? String
                                        
                                        
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
    
    func nextVC()
    {
        let rateVC = self.storyboard?.instantiateViewController(withIdentifier: "RateVehicleDealerViewController") as! RateVehicleDealerViewController
        
        rateVC.strQueryID = strQureyID
        rateVC.strVehicleID = self.vehicleID
        rateVC.strBrandID = self.brandID
        self.navigationController?.pushViewController(rateVC, animated: true)
    }
    
    @IBAction func btnOkClk(_ sender: Any)
    {
        self.popUpView.isHidden = true
    }
    
    
}


class QueryTableCell : UITableViewCell {

    @IBOutlet var lblDateCell: UILabel!
    @IBOutlet var lblRemaning: UILabel!
    @IBOutlet var lblDetailsCell: UILabel!
    @IBOutlet var lblServicePro: UILabel!
    @IBOutlet var imgServiceProvider: UIImageView!
    
}


class responseArrayServiceList
{
    var sp_id: String?
    var spName: String?
    var spAddress: String?
//    var spCity: String?
//    var offerDate : String?
//    var image : String?
//    var freePickUp : String?
//    var offer : String?
    

    init(sp_id:String, spName:String, spAddress:String)
    {
        self.sp_id = sp_id
        self.spName = spName
        self.spAddress = spAddress
//        self.spCity = spCity
//        self.image = image
//        self.freePickUp = freePickUp
//        self.offer = offer
    }
}

