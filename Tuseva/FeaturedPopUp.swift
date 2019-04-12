//
//  FeaturedPopUp.swift
//  Tuseva
//
//  Created by Praveen Khare on 29/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class FeaturedPopUp: UIViewController {

    var repairVC = RepairAndDescribeVC()
    var getSwitch = Bool()
    var actInd = UIActivityIndicatorView()
    
    var repairType: String = ""
    var desc: String = ""
    var strQueryID:String = ""
    
    
    var videoURL = NSURL()
    var image:UIImage?
    
    var isImage:String = ""
    var isVideo:String = ""
    
    var shareContact:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getSwitch = repairVC.switchValue
        
        print(getSwitch)
    }
    func handleTap() {
        self.view.removeFromSuperview()
    }

    
    @IBAction func btnProceedClk(_ sender: Any) {
        
        let fetureAd = self.storyboard?.instantiateViewController(withIdentifier: "fetured_ad") as? FeaturedAdVC
        
        fetureAd?.repairType = repairType
        fetureAd?.desc = desc
        fetureAd?.image = image
        fetureAd?.videoURL = videoURL
        fetureAd?.isImage = isImage
        fetureAd?.isVideo = isVideo
        fetureAd?.shareContact = shareContact
        self.navigationController?.pushViewController(fetureAd!, animated: true)
    
    }
    
    @IBAction func btnNoThanksClk(_ sender: Any) {
        
        if currentReachabilityStatus != .notReachable
        {
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                loginCheck(isActive: "")
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
                        //                            self.modelType()
                        //                        }
                        //                        else if isActive == "2"
                        //                        {
                        //                            self.varientType()
                        //                        }
                        //                        else
                        //                        {
                        self.upload()

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
    
//    func myImageUploadRequest()
//    {
//        actInd.startAnimating()
//        
//        
//        let myUrl = NSURL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=create_query_user");
//        
//        
//        let request = NSMutableURLRequest(url:myUrl! as URL);
//        request.httpMethod = "POST";
//        
//        
//        
//        let userID = UserDefaults.standard.value(forKey: "ID") as! String
//        let vehicleID = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
//        let brandID = UserDefaults.standard.value(forKey: "BrandIDService") as! String
//        let modelID = UserDefaults.standard.value(forKey: "modelIDService") as! String
//        let fuleID = UserDefaults.standard.value(forKey: "fuleIDService")as! String
//        let varientID = UserDefaults.standard.value(forKey: "varientIDService") as! String
//        let repairType = self.repairType
//        let desc = self.desc
//        
//        
//        
//        let param = ["id":"\(userID)",
//            "vehicle":"\(vehicleID)",
//            "brand":"\(brandID)",
//            "model":"\(modelID)",
//            "repair_type": "\(repairType)",
//            "description":"\(desc)",
//            "varient": "\(varientID)",
//            "fuel" : "\(fuleID)"]
//
//        
//        print(param)
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        
//        let imgData = UIImageJPEGRepresentation(image!, 0.2)
//        
//        if(imgData==nil)  { return; }
//        
//        
//        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imgData! as NSData, boundary: boundary) as Data
//        
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//            
//            print("REQ BODY>>\(request.url!)")
//            
//            if error != nil {
//                print("error=\(error!)")
//                self.actInd.stopAnimating()
//                return
//            }
//            
//            // You can print out response object
//            print("******* response = \(response!)")
//            
//            // Print out response body
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("****** response data = \(responseString!)")
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
//                
//                print(json!)
//                
//                
//                
//                if let responseCode = json?.value(forKey: "RESPONSECODE") as? Int
//                {
//                    var message : String?
//                    if responseCode == 0
//                    {
//                        message = json?.value(forKey:  "RESPONSE") as? String
//                        
//                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                            self.actInd.stopAnimating()
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                    else if responseCode == 1
//                    {
//                        let strRepairResponse:Int = json!.value(forKey:  "RESPONSEID") as! Int
//                        self.strQueryID = "\(strRepairResponse)"
//                        
//                        message = json?.value(forKey:  "RESPONSE") as? String
//                        
//                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                            self.goToNextVC()
//                            self.actInd.stopAnimating()
//                            
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                    
//                }
//            
//       
//            }catch
//            {
//                print(error)
//                
//            }
//            
//        }
//        task.resume()
//    }
//    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        let body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString(string: "--\(boundary)\r\n")
//                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString(string: "\(value)\r\n")
//            }
//        }
//        
//        let filename = "user-profile.jpg"
//        let mimetype = "image/jpg"
//        
//        body.appendString(string: "--\(boundary)\r\n")
//        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//        body.append(imageDataKey as Data)
//        body.appendString(string: "\r\n")
//        
//        
//        
//        body.appendString(string: "--\(boundary)--\r\n")
//        
//        return body
//    }
//    
//    
//    
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//
    
    
    
    
    
//    func uploadVideoImage()
//    {
//        actInd.startAnimating()
//        
//        
//        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
//        
//        
//        let userID = UserDefaults.standard.value(forKey: "ID") as! String
//        let vehicleID = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
//        let brandID = UserDefaults.standard.value(forKey: "BrandIDService") as! String
//        let modelID = UserDefaults.standard.value(forKey: "modelIDService") as! String
//        let fuleID = UserDefaults.standard.value(forKey: "fuleIDService")as! String
//        let varientID = UserDefaults.standard.value(forKey: "varientIDService") as! String
//        let repairType = self.repairType
//        let desc = self.desc
//        
//        
//        
//        let parameters = ["id":"\(userID)",
//            "vehicle":"\(vehicleID)",
//            "brand":"\(brandID)",
//            "model":"\(modelID)",
//            "repair_type": "\(repairType)",
//            "description":"\(desc)",
//            "varient": "\(varientID)",
//            "fuel" : "\(fuleID)"]
//
//        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        },
//                         to:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=create_query_user")
//        { (result) in
//            switch result {
//            case .success((let upload, _, _)):
//                
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
//                
//                upload.responseJSON { response in
//                    print(response.result.value!)
//                    
//                    let json = response.result.value as! NSDictionary
//                    
//                    let resCode = json.value(forKey: "RESPONSECODE") as? Int
//                    
//                    let msg = json.value(forKey: "RESPONSE") as? String
//                    
//                    if resCode == 1
//                    {
//                        let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
//                        
//                        alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                            self.actInd.stopAnimating()
//                        }))
//                        
//                        self.present(alertVC, animated: true, completion: nil)
//                    }
//                    else
//                    {
//                        let alertVC = UIAlertController(title: "Tuseva", message: msg, preferredStyle: .alert)
//                        
//                        alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                            self.actInd.stopAnimating()
//                        }))
//                        
//                        self.present(alertVC, animated: true, completion: nil)
//                    }
//                    
//                    DispatchQueue.main.async(execute: {
//                        
//                        self.actInd.stopAnimating()
//                        
////                        self.imgUser.setImageFromURl(stringImageUrl: "\(json.value(forKey: "RESPONSEIMG") as? String ?? "userImage")");
//                    });
//                }
//                
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
//        
//    }
    
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
        let shareCnt = self.shareContact
        
        
        var parameters = [String:String]()
        parameters = ["id":"\(userID)",
            "vehicle":"\(vehicleID)",
            "brand":"\(brandID)",
            "model":"\(modelID)",
            "repair_type": "\(repairType)",
            "description":"\(desc)",
            "varient": "\(varientID)",
            "fuel" : "\(fuleID)",
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
                                    
//                                    message = resJson.value(forKey:  "RESPONSE") as? String
//                                    
//                                    let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                        self.goToNextVC()
                                        self.actInd.stopAnimating()
                                        
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)
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

    
    
    func goToNextVC()
    {
        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(dashVC, animated: true)
    }
    
}
