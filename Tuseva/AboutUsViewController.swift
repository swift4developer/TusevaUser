//
//  AboutUsViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/4/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit
import Alamofire

class AboutUsViewController: UIViewController {
    
    @IBOutlet var RatePopUp: UIView!
    
    @IBOutlet var viewPopUp: UIView!
    
    @IBOutlet var btnStart1: UIButton!
    @IBOutlet var btnStar2: UIButton!
    @IBOutlet var btnStar3: UIButton!
    @IBOutlet var btnStar4: UIButton!
    @IBOutlet var btnStar5: UIButton!
    
    @IBOutlet var btnRate: UIButton!
    
    var str1 : Int = 0
    var str2 : Int = 0
    var str3 : Int = 0
    var str4 : Int = 0
    var str5 : Int = 0
    
    var strRate: String = ""
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var txtView: UITextView!
    
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnRateUs: UIButton!
    @IBOutlet var btnShare: UIButton!
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = UIColor.gray.cgColor
        txtView.layer.cornerRadius = 2
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(AboutUsViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "About Us"
        self.navigationItem.leftBarButtonItem = backBtn
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        RatePopUp.isUserInteractionEnabled = true
        RatePopUp.addGestureRecognizer(tap)
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            aboutUs()
        }
        else
        {
            alert()
        }
        
    }
    
    func handleTap()
    {
        RatePopUp.isHidden = true
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
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
                            self.likeUs()
                        }
                            else if isActive == "2"
                        {
                            self.RatingTuseva()
                        }
                        else
                        {
                            self.aboutUs()
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

    
    func aboutUs()
    {
        actInd.startAnimating()
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=about_us")!
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
                            self.txtView.text = resJson.value(forKey:  "RESPONSE") as? String
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
    
    func gotoNextVC()
    {
        let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }

    
    @IBAction func btnLikeClk(_ sender: Any)
    {
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "1")
//            likeUs()
        }
        else
        {
            alert()
        }
    }
    
    func likeUs()
    {
        actInd.startAnimating()
        
        let userId = UserDefaults.standard.value(forKey: "ID") as? String
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=like_us&user_id=\(userId!)")!
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
    
    @IBAction func btnRateUsClk(_ sender: Any)
    {
        RatePopUp.isHidden = false
//        let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
//        self.navigationController?.pushViewController(ratingVC, animated: true)
    }
    
    @IBAction func btnStarClk(_ sender: Any)
    {
        let btn: UIButton = sender as! UIButton
        switch btn.tag
        {
        case 1:
            
            if str1 == 0
            {
                btnStart1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str1 = 1
                
                strRate = "1"
                
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
                btnStart1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str2 = 1
                strRate = "2"
                
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
                btnStart1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str3 = 1
                
                strRate = "3"
                
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
                btnStart1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
                str4 = 1
                strRate = "4"
                
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
                btnStart1.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar2.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar3.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar4.setImage(UIImage(named:"star_filled"), for: .normal)
                btnStar5.setImage(UIImage(named:"star_filled"), for: .normal)
                str5 = 1
                strRate = "5"
                
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
        btnStart1.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar2.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar3.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar4.setImage(UIImage(named:"star_unfilled"), for: .normal)
        btnStar5.setImage(UIImage(named:"star_unfilled"), for: .normal)
    }

    
    @IBAction func btnRateClk(_ sender: Any)
    {
        if strRate == ""
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please rate first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.actInd.stopAnimating()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            loginCheck(isActive: "2")
        }

    }
    
    func RatingTuseva()
    {
        actInd.startAnimating()
        
        let userId = UserDefaults.standard.value(forKey: "ID") as? String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=rate_us&user_id=\(userId!)&rate=\(strRate)".replacingOccurrences(of: " ", with: "%20")
        
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
                                self.RatePopUp.isHidden = true
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == 1
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                                
                                self.RatePopUp.isHidden = true
                                
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
    
    @IBAction func btnShareClk(_ sender: Any)
    {
        
        let textToShare = txtView.text!
        
//        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // exclude some activity types from the list (optional)
        activityVC.excludedActivityTypes = [ UIActivityType.airDrop]

        
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
//        }
    }
        
//        // share image
//        @IBAction func shareImageButton(_ sender: UIButton) {
//            
//            // image to share
//            let image = UIImage(named: "Image")
//            
//            // set up activity view controller
//            let imageToShare = [ image! ]
//            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//            
//            // exclude some activity types from the list (optional)
//            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
//
//            // present the view controller
//            self.present(activityViewController, animated: true, completion: nil)
//        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
