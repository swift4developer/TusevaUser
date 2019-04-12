
//
//  ManageVehicleVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 31/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ManageVehicleVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var arrManageVehicle = [ManageVehicle]()
    
    @IBOutlet var tblView: UITableView!
    
    var actInd = UIActivityIndicatorView()
    
    @IBAction func btnPlusClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            let addManageVC = self.storyboard?.instantiateViewController(withIdentifier: "AddManageVehicleVC") as!
            AddManageVehicleVC
            
            addManageVC.strIsPlus = "1"
            self.navigationController?.pushViewController(addManageVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tblView.separatorColor = UIColor.clear
        
//        let filterImage   = UIImage(named: "filter")!
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ManageVehicleVC.didTapBackButton(sender:)))
        
//        let filterBtn = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(ManageVehicleVC.didTapFilterButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Manage Vehicle"
//        self.navigationItem.rightBarButtonItem = filterBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck()
//            manageVehicleHist()
        }
        else
        {
            print("Internet connection FAILED")
            
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
                        self.manageVehicleHist()
                        
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
    
    func manageVehicleHist()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//                let userID:String = "63"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=manage_vehicle_user&user_id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrManageVehicle.removeAll()
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
                                    let serviceDate = arrData["model_year"] as? String
                                    let brand = arrData["brand"] as? String
                                    let model = arrData["model"] as? String
                                    let image = arrData["image"] as? String
                                    let varient = arrData["varient"] as? String
                                    let description = arrData["description"] as? String
                                    guard let fuel = arrData["fuel"] as? String else
                                    {
                                        return
                                    }
                                    
                                    let s = ManageVehicle(id:id!, serviceDate:serviceDate!, brand:brand!, model:model!, fuel:fuel, image:image!, varient:varient!, description: description!)
                                    
                                    self.arrManageVehicle.append(s)
                                }
//
//                                print(self.arrServiceHistory)
                                
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
        return arrManageVehicle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManageVehicleTableViewCell
        
        
        cell.lblModel.text = arrManageVehicle[indexPath.section].brand
        cell.lblDate.text = "\(arrManageVehicle[indexPath.section].model!) \(arrManageVehicle[indexPath.section].serviceDate!)"
        
        cell.lblDescription.text = arrManageVehicle[indexPath.section].varient
        
        let imgURL = arrManageVehicle[indexPath.section].image
        cell.imgCar.setImageFromURl(stringImageUrl: imgURL!)
        cell.imgCar.clipsToBounds = true
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addManageVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailViewController") as! VehicleDetailViewController
        
        //        addManageVC.strIsPlus = "0"
        //        addManageVC.strVehicle = arrManageVehicle[indexPath.section].id!
        
        addManageVC.strVehicleID = arrManageVehicle[indexPath.section].id!
        self.navigationController?.pushViewController(addManageVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
//    {
//        
//    }

}

class ManageVehicleTableViewCell: UITableViewCell
{
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblDate: UILabel!
    
 
}

class ManageVehicle
{
    var id:String?
    var serviceDate:String?
    var brand:String?
    var model:String?
    var fuel : String?
    var image:String?
    var varient:String?
    var description:String?
    
    init(id:String, serviceDate:String, brand:String, model:String, fuel:String, image:String, varient:String, description: String)
    {
        self.id = id
        self.varient = varient
        self.brand = brand
        self.image = image
        self.model = model
        self.description = description
        self.serviceDate = serviceDate
        self.fuel = fuel
    }

}
