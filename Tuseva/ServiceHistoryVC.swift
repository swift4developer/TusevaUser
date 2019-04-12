

//
//  ServiceHistoryVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 31/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ServiceHistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var arrServiceHistory = [ServiceHistory]()
    
    @IBOutlet var tblView: UITableView!
    
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
        
        
//        let filterImage   = UIImage(named: "filter")!
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ServiceHistoryVC.didTapBackButton(sender:)))
        
//        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ServiceHistoryVC.didTapFilterButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Service History"
//        self.navigationItem.rightBarButtonItem = filterBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        if currentReachabilityStatus != .notReachable
        {
            self.loginCheck()
//            serviceHistory()
        }
        else
        {
            alert()
        }
    }
    
    func didTapBackButton(sender: AnyObject){
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
    func didTapFilterButton(sender: AnyObject){
        print("Setting btn tapped")
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
                        
//                        if self.isActive == "1"
//                        {
//                            self.addService()
//                        }
//                        else
//                        {
                            self.serviceHistory()
                        
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

    
    func serviceHistory()
    {
        actInd.startAnimating()
//        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
                let userID:String = "303"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=service_history_user&user_id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrServiceHistory.removeAll()
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
                                    let serviceDate = arrData["query_date"] as? String
                                    let modelYear = arrData["model_year"] as? String
                                    let model = arrData["model"] as? String
//                                    let image = arrData["image"] as? String
                                    
                                    var image = ""
                                    
                                    if let arrImage = arrData.value(forKey:  "file") as? [AnyObject]
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
                                    
                                    let desc = arrData["detail_description"] as? String
                                    
                                    let resCount:Int = arrData["no_of_response"] as! Int
                                    
                                    let response:String = "\(resCount)"
                                    
                                    let s = ServiceHistory(id: id!, serviceDate: serviceDate!, modelYear: modelYear!, model: model!, image: image, description: desc!, response: response)
                                    self.arrServiceHistory.append(s)
                                }
                                
                                print(self.arrServiceHistory)
                                
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
        return arrServiceHistory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceHistoryTableViewCell
        
       cell.lblServiceName.text = arrServiceHistory[indexPath.section].description
        cell.lblModel.text = "\(arrServiceHistory[indexPath.section].model!) \(arrServiceHistory[indexPath.section].modelYear!)"
        cell.lblServiceDate.text = "Last Service \(arrServiceHistory[indexPath.section].serviceDate!)"
        cell.lblResponseCount.layer.cornerRadius = 8
        cell.lblResponseCount.clipsToBounds = true
        cell.lblResponseCount.text = "\(arrServiceHistory[indexPath.section].response!)"
        
        let imgURL = arrServiceHistory[indexPath.section].image
        cell.imgCar.setImageFromURl(stringImageUrl: imgURL!)
        cell.imgCar.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    @IBAction func btnPlusClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            let addManageVC = self.storyboard?.instantiateViewController(withIdentifier: "AddServiceVC") as!
            AddServiceVC
            self.navigationController?.pushViewController(addManageVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }

}

class ServiceHistory
{
    var id:String?
    var serviceDate:String?
    var modelYear:String?
    var model:String?
    var image:String?
    var description:String?
    var response:String?
    
    init(id:String, serviceDate:String, modelYear:String, model:String, image:String, description:String, response:String) {
        self.id = id
        self.description = description
        self.modelYear = model
        self.image = image
        self.model = model
        self.serviceDate = serviceDate
        self.response = response
    }
}

class ServiceHistoryTableViewCell : UITableViewCell
{
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblServiceName: UILabel!
    
    @IBOutlet var lblServiceDate: UILabel!
    
    @IBOutlet var lblModel: UILabel!
  
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblResponseCount: UILabel!
}
