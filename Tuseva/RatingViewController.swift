//
//  RatingViewController.swift
//  Tuseva
//
//  Created by oms183 on 8/31/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class RatingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    
    var arrRating = [responseRating]()
    
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
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(RatingViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Rating & Reviews"
        self.navigationItem.leftBarButtonItem = backBtn
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            rating()
        }
        else
        {
            alert()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    func didTapBackButton(sender: AnyObject)
    {
        
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
                        
//                        if isActive == "1"
//                        {
//                            self.likeUs()
//                        }
//                        else
//                        {
                            self.rating()
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


    func rating()
    {
        actInd.startAnimating()
        let userId:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userId:String = "62"
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=rating_list&id=\(userId)")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
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
                            if let response = resJson.value(forKey: "RESPONSE") as? [AnyObject]
                            {
                                for arr in response
                                {
                                    let rating_id = arr["id"] as? String
                                    
                                    let description = arr["description"] as? String
                                    
                                    let service_provider_name = arr["service_provider_name"] as? String
                                    
                                    let rate = arr["rate"] as? String
                                    
                                    let image = arr["image"] as? String
                                    
                                    let rate_date = arr["rate_date"] as? String
                                    
                                    let rate_time = arr["rate_time"] as? String
                                    
                                    let r = responseRating(rating_id: rating_id!, rate: rate!, rate_date: rate_date!, rate_time: rate_time!, desc: description!, image: image!, service_provider_name: service_provider_name!)
                                    
                                    self.arrRating.append(r)
                                }
                                
                                self.tblView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RatingTableViewCell
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        
        cell.lblTitle.text = arrRating[indexPath.row].service_provider_name
        
        cell.lblDate.text = "\(arrRating[indexPath.row].rate_date!) \(arrRating[indexPath.row].rate_time!)"
        
        cell.lblDescription.text = arrRating[indexPath.row].desc
        
        cell.imgProfile.setImageFromURl(stringImageUrl: arrRating[indexPath.row].image)
        
        
        let rating:Int = Int(arrRating[indexPath.row].rate!)!
        
        switch rating {
        case 0:
            
            cell.btnStar1.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            
        case 1:
            
            cell.btnStar1.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            
        case 2:
            
            cell.btnStar1.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            
        case 3:
            
            cell.btnStar1.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            
        case 4:
            
            cell.btnStar1.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_unfilled"), for: UIControlState.normal)
            
        case 5:
            
            cell.btnStar1.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar2.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar3.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar4.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            cell.btnStar5.setImage(UIImage(named: "star_filled"), for: UIControlState.normal)
            
        default:
            break
        }

    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}

class RatingTableViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnStar1: UIButton!    
    @IBOutlet var btnStar2: UIButton!
    @IBOutlet var btnStar3: UIButton!
    @IBOutlet var btnStar4: UIButton!
    @IBOutlet var btnStar5: UIButton!
    
}

class responseRating
{
    var rating_id:String?
    
    var rate:String?
    
    var rate_date:String?
    
    var rate_time:String?
    
    var desc:String?
    
    var service_provider_name:String?
    
    var image:String!
    
    init(rating_id:String, rate:String,rate_date:String, rate_time:String, desc:String, image:String,service_provider_name:String) {
        
        self.desc = desc
        
        self.image = image
        
        self.service_provider_name = service_provider_name
        
        self.rate = rate
        
        self.rate_date = rate_date
        
        self.rate_time = rate_time
        
        self.rating_id = rating_id
    }

}
