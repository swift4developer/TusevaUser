
//
//  PopUpCallVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 01/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class PopUpCallVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

   

    @IBOutlet var btnClose: UIButton!
    @IBOutlet var tblView: UITableView!
    
    var callMobileNo = [responseArrayCall]()
    
    var mobileID :String = ""
    
    var strSpId:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        self.btnClose.layer.cornerRadius = self.btnClose.frame.size.height / 2
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        
        btnClose.bringSubview(toFront: tblView)
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            CallList()
        }
        else
        {
            print("Internet connection FAILED")
            
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
                        
//                        if isActive == "1"
//                        {
//                            self.Review()
//                        }
//                        else
//                        {
                            self.CallList()
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
    

  
    func CallList()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=mobile_no_list&service_station_id=\(strSpId)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.callMobileNo.removeAll()
                    
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
                                    
                                    guard let mobile_no = arrData["mobile_no"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayCall(mobileNo:mobile_no, id:id!)
                                    
                                    self.callMobileNo.append(r)
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
    
    func handleTap() {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnCloseClk(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callMobileNo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myCell
        cell.lblNumber.text = callMobileNo[indexPath.row].mobileNo
        
        cell.btnCall.tag = indexPath.row
        
        cell.btnCall.addTarget(self,action:#selector(btnCallClk(sender:)), for: .touchUpInside)

        return cell
    }
    
    func btnCallClk(sender:UIButton)
    {
        let mobileNo:String? = callMobileNo[sender.tag].mobileNo
        guard let number = URL(string: "telprompt://\(mobileNo!)")
        else
        {
            return
        }
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(number)
        }
        else
        {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
}

class myCell: UITableViewCell {

    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var btnCall: UIButton!
}

class responseArrayCall {
    var mobileNo : String?
    var id : String?
    
    init(mobileNo:String, id:String) {
        self.mobileNo = mobileNo
        self.id = id
    }
}

