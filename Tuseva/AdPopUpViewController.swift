//
//  AdPopUpViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 27/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class AdPopUpViewController: UIViewController {

    @IBOutlet var btnCall: UIButton!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var lblOfferDesc: UILabel!
    @IBOutlet var lblOffer: UILabel!
    @IBOutlet var btnClose: UIButton!
    
    @IBOutlet var imgVehicle: UIImageView!
    var strCity:String = ""
    
    var strlink:String = ""
    
    var dict = NSMutableDictionary()
    
    var actInd = UIActivityIndicatorView()
    
    @IBAction func btnCloseClk(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.btnCall.layer.cornerRadius = 2
        self.btnClose.layer.cornerRadius = self.btnClose.frame.size.height / 2
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(handleTapImage))
        imgVehicle.isUserInteractionEnabled = true
        imgVehicle.addGestureRecognizer(tap1)
        
        
        self.lblOffer.text = dict.value(forKey:"title") as? String
        self.lblOfferDesc.text = dict.value(forKey:"description") as? String
        self.lblPhoneNo.text = dict.value(forKey:"mobile") as? String

        let imgURL = dict.value(forKey:"image")
        self.imgVehicle.setImageFromURl(stringImageUrl: imgURL as! String)

        self.strlink = dict.value(forKey: "link") as! String

        
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func handleTap() {
//        print("tapped")
//        self.view.removeFromSuperview()
    }
    
    func handleTapImage()
    {
        guard let url = URL(string: strlink) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
//    func showOffer()
//    {
//        actInd.startAnimating()
////        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=offer_discount")!
//        
//        let url : URLConvertible = URL(string:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=advertisement_user&city=\(strCity)")!
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
//                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSArray
//                            {
//                                for i in resValue
//                                {
//                                    if let dict = i as? NSDictionary
//                                    {
//                                        
//                                        self.lblOffer.text = dict.value(forKey:"title") as? String
//                                        self.lblOfferDesc.text = dict.value(forKey:"description") as? String
//                                        self.lblPhoneNo.text = dict.value(forKey:"mobile") as? String
//                                        
//                                        let imgURL = dict.value(forKey:"image")
//                                        self.imgVehicle.setImageFromURl(stringImageUrl: imgURL as! String)
//                                        
//                                        self.strlink = dict.value(forKey: "link") as! String
//                                        
//                                    }
//                                    
//                                    
//                                }
//                                
//                            }
//                            
//                            self.actInd.stopAnimating()
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
    
    
    @IBAction func btnCallClk(_ sender: Any)
    {
        let mobileNo:String? = lblPhoneNo.text
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
