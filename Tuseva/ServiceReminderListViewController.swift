//
//  ServiceReminderListViewController.swift
//  Tuseva
//
//  Created by oms183 on 9/16/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ServiceReminderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnPlus: UIButton!
    
    var actInd = UIActivityIndicatorView()
    
    var arrService = [responseArrayServiceReminder]()
    var strReminderID:String = ""
    var isReveal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        let filterImage   = UIImage(named: "filter")!
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ServiceReminderListViewController.didTapBackButton(sender:)))
        
//        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ServiceHistoryVC.didTapFilterButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Service Reminder List"
//        self.navigationItem.rightBarButtonItem = filterBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            serviceReminderList()
        }
        else
        {
            alert()
        }
    }
    
    func didTapBackButton(sender: AnyObject)
    {
        if isReveal == "1"
        {
            let revealController: SWRevealViewController? = revealViewController()
            let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
            
            let navigationController = UINavigationController(rootViewController: dashVC)
            
            revealController?.pushFrontViewController(navigationController, animated: true)
            
        }
        else
        {

            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    func didTapFilterButton(sender: AnyObject){
//        print("Setting btn tapped")
//    }
    
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
//                            self.addServiceReminder()
//                        }
//                        else
//                        {
                            self.serviceReminderList()
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


    func serviceReminderList()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userID:String = "62"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=service_reminder_list&user_id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrService.removeAll()
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
                                    
                                    let id = arrData["id"] as? String
                                    let date = arrData["reminder_date"] as? String
                                    let brand = arrData["vehicle_brand"] as? String
                                    let model = arrData["vehicle_model"] as? String
                                    let image = arrData["image"] as? String
                                    let desc = arrData["description"] as? String
                                    
                                    
                                    let s = responseArrayServiceReminder(id: id!, brand: brand!, model: model!, date: date!, desc: desc!, image: image!)
                                    self.arrService.append(s)
                                }
                                
                                print(self.arrService)
                                
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrService.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceReminderTableViewCell
        
        cell.lblBrand.text = arrService[indexPath.section].brand
        cell.lblModel.text = arrService[indexPath.section].model
        cell.lblDate.text = arrService[indexPath.section].date
        cell.lblDesc.text = arrService[indexPath.section].desc
        
        let imgURL = arrService[indexPath.section].image
        cell.imgVehicle.setImageFromURl(stringImageUrl: imgURL!)
        cell.imgVehicle.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func btnPlusClk(_ sender: Any)
    {
        let serviceRemVC = self.storyboard?.instantiateViewController(withIdentifier: "AddServiceReminderViewController") as! AddServiceReminderViewController
        self.navigationController?.pushViewController(serviceRemVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

class ServiceReminderTableViewCell: UITableViewCell
{
    @IBOutlet var imgVehicle: UIImageView!
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblBrand: UILabel!
}

class responseArrayServiceReminder
{
    var id:String?
    var brand:String?
    var model:String?
    var date:String?
    var desc:String?
    var image:String?
    
    init(id:String, brand:String, model:String, date:String, desc:String, image:String)
    {
        self.id = id
        self.brand = brand
        self.model = model
        self.date = date
        self.desc = desc
        self.image = image
    }
}

