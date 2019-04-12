//
//  ServiceStationNameVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 01/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ServiceStationNameVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var lblAll: UILabel!
    @IBOutlet var viewAll: UIView!
    @IBOutlet var lblRatePoints: UILabel!
    @IBOutlet var reviewVC: UIView!
    @IBOutlet var tblViewReview: UITableView!
    @IBOutlet var viewReview: UIView!
    @IBOutlet var viewServiceStation: UIView!
    @IBOutlet var lblReviews: UILabel!
    @IBOutlet var lblSelectedTab: UILabel!
    @IBOutlet var lblBadge: UILabel!
    
    @IBOutlet var imgProvider: UIImageView!
    
    @IBOutlet var imgVerify: UIImageView!
    @IBOutlet var btnPhoto: UIButton!
    
    @IBOutlet var viewRating: UIView!
    
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var btnRate: UIButton!
    
    @IBOutlet var lblSPName: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgVerified: UIImageView!
    
    @IBOutlet var lblOpenTime: UILabel!
    
    @IBOutlet var btnSendMsg: UIButton!
    @IBOutlet var lblTime1: UILabel!
    @IBOutlet var lblTime2: UILabel!
    @IBOutlet var lblTime3: UILabel!
    @IBOutlet var lblTime4: UILabel!
    @IBOutlet var lblTime5: UILabel!
    @IBOutlet var lblTime6: UILabel!
    @IBOutlet var lblTime7: UILabel!
    
    @IBOutlet var btnReview: UIButton!
    @IBOutlet var btnServiceStation: UIButton!
    @IBOutlet var btnCall: UIButton!
    
    @IBOutlet var lblBaseReview: UILabel!
    @IBOutlet var imgStar1: UIImageView!
   
    @IBOutlet var imgStar2: UIImageView!
    
    @IBOutlet var imgStar5: UIImageView!
    @IBOutlet var imgStar4: UIImageView!
    @IBOutlet var imgStar3: UIImageView!
    
    var strSpID:String = ""
    
    var strImageName:String = ""
    
    var arrRating = [responseArrayRatingList]()
    var strRatingID: String = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        win.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        
        lblSelectedTab.backgroundColor = UIColor(red:0.94, green:0.25, blue:0.19, alpha:1.0)
        lblReviews.backgroundColor = UIColor.black
        
        lblBadge.layer.cornerRadius = lblBadge.frame.size.height/2
        lblBadge.layer.masksToBounds = true
        
        viewServiceStation.isHidden = false
        viewReview.isHidden = true
        
        tblViewReview.tableFooterView = viewAll
        tblViewReview.tableHeaderView = viewRating
        
        navigation()
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            serviceProviderDetail()
        }
        else
        {
            alert()
        }
        
    }
    
    func navigation()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        
        //"filled_heart"
        let navUserImage = UIImage(named: strImageName)?.withRenderingMode(.alwaysOriginal)
        let  imgView = UIImageView(image: navUserImage)
        imgView.frame =   CGRect(x: 0, y: 0, width: 28, height: 28)
        
        let leftBtn = UIBarButtonItem.init(customView: imgView)
        
        let backImage = UIImage(named: "backbtn")!
        
        //        let heartBtn = UIBarButtonItem(image: navUserImage, landscapeImagePhone: navUserImage, style: .plain, target: self, action: #selector(ServiceStationNameVC.didTapHeartButton(sender:)))
        
        let backBtn = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ServiceStationNameVC.didTapBackButton(sender:)))
        
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = ""
        self.navigationItem.rightBarButtonItem = leftBtn
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "nav_bg")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 15, 0, 15), resizingMode: UIImageResizingMode.stretch)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapHeartButton(sender: AnyObject)
    {
        
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
                            self.Review()
                        }
//                        else if isActive == "2"
//                        {
//                            self.varientType()
//                        }
//                        else if isActive == "4"
//                        {
//                            self.createQueryBuy(shareCnt: "1")
//                        }
//                        else if isActive == "5"
//                        {
//                            self.createQueryBuy(shareCnt: "0")
//                        }
                        else
                        {
                            self.serviceProviderDetail()
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
    

    
    func serviceProviderDetail()
    {
        actInd.startAnimating()
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        
        //        let userID:String = "5"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=service_station_detail&sp_id=\(strSpID)&user_id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        
        print("url >>> \(url)")
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
                                        self.lblSPName.text = dict.value(forKey: "sp_name") as? String
                                        self.lblAddress.text = dict.value(forKey: "sp_address") as? String
                                        self.lblMobile.text = dict.value(forKey: "sp_mobile") as? String
                                        
//                                        let like:Int = dict.value(forKey: "like") as! Int
                                        
//                                        let strLike:String = "\(like)"
                                        
//                                        if strLike == "0"
//                                        {
//                                            self.strImageName = "like"
//                                        }
//                                        else
//                                        {
//                                            self.strImageName = "filled_heart"
//                                        }
//                                        self.navigation()
                                        
                                        let count:Int = dict.value(forKey: "reviewcount") as! Int
                                        let strCount:String = "\(count)"
                                        self.lblBadge.text = strCount
                                        
                                        self.lblRatePoints.text = strCount
                                        
                                        var image = ""
                                        
                                        if let arrImage = dict.value(forKey: "image") as? [AnyObject]
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
                                        
                                        let imgURL = image 
                                        self.imgProvider.setImageFromURl(stringImageUrl: imgURL)

                                        
                                        if dict.value(forKey: "verified") as! Int == 1
                                        {
                                            self.imgVerified.isHidden = false
                                            self.imgVerify.isHidden = false
                                        }
                                        else
                                        {
                                            self.imgVerified.isHidden = true
                                            self.imgVerify.isHidden = true
                                        }
                                        
                                        let monday = dict.value(forKey: "monday") as! String
                                        self.lblTime1.text = "Monday:\(monday)"
                                        
                                        let tuesday = dict.value(forKey: "tuesday") as! String
                                        self.lblTime2.text = "Tuesday:\(tuesday)"
                                        
                                        let wednesday = dict.value(forKey: "wednesday") as! String
                                        self.lblTime3.text = "Wednesday:\(wednesday)"
                                        
                                        let thursday = dict.value(forKey: "thursday") as! String
                                        self.lblTime4.text = "Thursday:\(thursday)"
                                        
                                        let friday = dict.value(forKey: "friday") as! String
                                        self.lblTime5.text = "Friday:\(friday)"
                                        
                                        let saturday = dict.value(forKey: "saturday") as! String
                                        self.lblTime6.text = "Saturday:\(saturday)"
                                        
                                        let sunday = dict.value(forKey: "sunday") as! String
                                        self.lblTime7.text = "Sunday:\(sunday)"
                                        
//                                        guard let strRate = dict.value(forKey: "rating") as? String
//                                            else
//                                        {
//                                            return
//                                        }
//                                        self.lblRating.text = "\(strRate)/5)"
                                    }
                                    
                                    
                                }
                                
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
    
    @IBAction func btnPhotosClk(_ sender: Any) {
    }
    
    @IBAction func btnCallClk(_ sender: Any) {
        let popVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpCallVC") as? PopUpCallVC
        
        var frame: CGRect = popVC!.view.frame;
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        popVC?.view.frame = frame;
        
        popVC?.strSpId = strSpID
        
        self.addChildViewController(popVC!)
        self.view.addSubview((popVC?.view)!)
        popVC?.didMove(toParentViewController: self)
    }
    
    @IBAction func btnReviewsClk(_ sender: Any)
    {
        lblReview.backgroundColor = UIColor(red:0.94, green:0.25, blue:0.19, alpha:1.0)
        lblSelectedTab.backgroundColor = UIColor.black
        
        
        viewServiceStation.isHidden = true
        viewReview.isHidden = false
        
      if currentReachabilityStatus != .notReachable
      {
        loginCheck(isActive: "1")
//        Review()
      }
      else
      {
        alert()
      }
    }
    
    func Review()
    {
        actInd.startAnimating()
        let userID  = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userID = "62"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=rating_list&id=\(userID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrRating.removeAll()
                    
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
                                
                                let count:Int = resJson.value(forKey: "based_on") as! Int
                                let base = "\(count)"
                                self.lblBaseReview.text = "Based on \(base) reviews"
                                
                                let rate =  resJson.value(forKey:  "sp_rate") as? String
                                
                                let floatValue = Float(rate!)
                                
                                let duration = String(format: "%.2f", floatValue!)
                                self.lblRatePoints.text = "\(duration)/5"
                                
                                for arrData in resValue {
                                    
                                    let spName = arrData["service_provider_name"] as? String
                                    
                                    let spdesc = arrData["description"] as? String
                                    let image = arrData["image"] as? String
//                                    let rate = arrData["rate"] as? String
                                    let rateDate = arrData["rate_date"] as? String
                                    let rateTime = arrData["rate_time"] as? String

                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    
                                    let r = responseArrayRatingList(id:id!, spName:spName!, image:image!, desc:spdesc!, rateDate:rateDate!, rateTime:rateTime!)
                                    
                                    self.arrRating.append(r)
                                }
                                DispatchQueue.main.async(execute: {
                                    self.tblViewReview.reloadData()
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
    
    @IBAction func btnRateClk(_ sender: Any) {
    }
    
    @IBAction func btnServiceStationClk(_ sender: Any) {
      
        lblSelectedTab.backgroundColor = UIColor(red:0.94, green:0.25, blue:0.19, alpha:1.0)
        lblReviews.backgroundColor = UIColor.black
        
        viewServiceStation.isHidden = false
        viewReview.isHidden = true
        
        serviceProviderDetail()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! reviewsTableViewCell
        
        cell.lblDescription.text = arrRating[indexPath.row].desc
//        cell.lblCount.text = arrRating[indexPath.row].rate
        cell.lblDate.text = arrRating[indexPath.row].rateDate
        
        let imgURL:String = arrRating[indexPath.row].image!
        cell.imgProfile.setImageFromURl(stringImageUrl: imgURL)
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
        cell.imgProfile.clipsToBounds = true
        
        cell.lblCount.layer.cornerRadius = 10
        cell.lblCount.clipsToBounds = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
       
    @IBAction func btnSendMsgClk(_ sender: Any)
    {
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        
        contactVC.strIsMsg = "1"
        contactVC.strSpID = strSpID
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    
}

class reviewsTableViewCell: UITableViewCell
{
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var lblDate: UILabel!
}

class responseArrayRatingList
{
    var id:String?
    var spName:String?
    var image:String?
    var desc:String?
    var rateDate:String?
    var rateTime:String?
    
    init(id:String, spName:String, image:String, desc:String, rateDate:String, rateTime:String)
    {
        self.id = id
        self.spName = spName
        self.image = image
        self.desc = desc
        self.rateDate = rateDate
        self.rateTime = rateTime
    }
}
