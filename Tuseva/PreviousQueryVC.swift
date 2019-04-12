//
//  QueryDetailsVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 03/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class PreviousQueryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cellLoad: String = "active"
    
    @IBOutlet var tblViewActive: UITableView!
    
    @IBOutlet var tblViewInActive: UITableView!
    
    @IBOutlet var lblInActive: UILabel!
    @IBOutlet var lblActive: UILabel!
    
    var arrActiveQuery = [responseActiveQuery]()
    var strActiveQuery:String = ""
    
    var arrInActiveQuery = [responseInActiveQuery]()
    var strInActiveQuery:String = ""
    
    var arrImageData:Array = [String?]()
    
    var actInd = UIActivityIndicatorView()
    
    var isReveal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        lblInActive.backgroundColor = UIColor.black
       
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(PreviousQueryVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "My Previous Query"
        self.navigationItem.leftBarButtonItem = backBtn
        
        tblViewInActive.isHidden = true
        tblViewActive.isHidden = false
        
        if currentReachabilityStatus != .notReachable
        {
            activeQueryList()
        }
        else
        {
            alert()
        }
    }

    func didTapBackButton(sender: AnyObject){
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
    
    @IBAction func btnActiveClk(_ sender: Any)
    {
        cellLoad = "active"
        lblActive.backgroundColor = UIColor(red:0.95, green:0.25, blue:0.19, alpha:1.0)
        lblInActive.backgroundColor = UIColor.black
        
        tblViewInActive.isHidden = true
        tblViewActive.isHidden = false
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            activeQueryList()
        }
        else
        {
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
                        self.activeQueryList()
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
    

    
    func activeQueryList()
    {
        actInd.startAnimating()
        let userId:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userId:String = "62"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=my_query_list_user&id=\(userId)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrActiveQuery.removeAll()
                    
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
                                    
                                    guard let model = arrData["model"] as? String
                                        else
                                    {
                                        return
                                    }
                                    guard let modelYear = arrData["model_year"] as? String
                                    else
                                    {
                                        return
                                    }
                                    guard let detailDesc = arrData["detail_description"] as? String
                                    else
                                    {
                                        return
                                    }
                                    guard let queryDate = arrData["query_date"] as? String
                                    else
                                    {
                                        return
                                    }

                                    
                                    var image = ""
                                    
                                    if let arrImage = arrData.value(forKey:  "image") as? [AnyObject]
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
                                    
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseActiveQuery(model:model, id:id!, modelYear:modelYear, detailDesc:detailDesc, queryDate:queryDate, image:image)
                                    
                                    self.arrActiveQuery.append(r)
                                    
                                    print("arr:\(self.arrActiveQuery)")

                                }
                                
                                
                                DispatchQueue.main.async(execute:
                                    {
                                    self.tblViewActive.reloadData()
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
    
    @IBAction func btnInActiveClk(_ sender: Any)
    {
        cellLoad = "inActive"
        lblInActive.backgroundColor = UIColor(red:0.95, green:0.25, blue:0.19, alpha:1.0)
        lblActive.backgroundColor = UIColor.black
        
        tblViewInActive.isHidden = false
        tblViewActive.isHidden = true
        
        if currentReachabilityStatus != .notReachable
        {
            inActiveQuery()
        }
        else
        {
            alert()
        }
    }

    
    func inActiveQuery()
    {
        actInd.startAnimating()
        let userId:String = UserDefaults.standard.value(forKey: "ID") as! String
        
//        let userId:String = "62"
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=my_query_list_user_inactive&id=\(userId)".replacingOccurrences(of: " ", with: "%20")
        
//        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=my_query_list_user&id=\(userId)".replacingOccurrences(of: " ", with: "%20")

        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.arrInActiveQuery.removeAll()
                    
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
                                    
                                    guard let model = arrData["model"] as? String
                                        else
                                    {
                                        return
                                    }
                                    guard let modelYear = arrData["model_year"] as? String
                                        else
                                    {
                                        return
                                    }
                                    guard let detailDesc = arrData["detail_description"] as? String
                                        else
                                    {
                                        return
                                    }
                                    guard let queryDate = arrData["query_date"] as? String
                                        else
                                    {
                                        return
                                    }
                                    
                                    
                                    var image = ""
                                    
                                    if let arrImage = arrData.value(forKey:  "image") as? [AnyObject]
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
                                    
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseInActiveQuery(model:model, id:id!, modelYear:modelYear, detailDesc:detailDesc, queryDate:queryDate, image:image)
                                    
                                    self.arrInActiveQuery.append(r)
                                    
                                    print("arr:\(self.arrInActiveQuery)")
                                    
                                }
                                DispatchQueue.main.async(execute:
                                    {
                                        self.tblViewInActive.reloadData()
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if cellLoad == "active"
        {
            return arrActiveQuery.count
        }
        else
        {
            return arrInActiveQuery.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if cellLoad == "active"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActiveQueryCell
            
            cell.lblQueryPending.isHidden = true
            cell.lblQueryPending.layer.cornerRadius = 10.0
            cell.lblQueryPending.clipsToBounds = true

            cell.lblTitle.text = arrActiveQuery[indexPath.section].model
            cell.lblSubTitle.text = arrActiveQuery[indexPath.section].detailDesc
            cell.lblDate.text = arrActiveQuery[indexPath.section].queryDate
            
            
            if arrActiveQuery[indexPath.section].image != ""
            {
                let imgURL = arrActiveQuery[indexPath.section].image!
                cell.imgQuery.setImageFromURl(stringImageUrl: imgURL )
            }
            
            print("image:\(arrActiveQuery[indexPath.section].image!)")
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InactiveQueryCell
            
            cell.lblQueryPending.isHidden = true
            cell.lblQueryPending.layer.cornerRadius = 10.0
            cell.lblQueryPending.clipsToBounds = true

            cell.lblTitle.text = arrInActiveQuery[indexPath.section].model
            cell.lblSubTitle.text = arrInActiveQuery[indexPath.section].detailDesc
            cell.lblDate.text = arrInActiveQuery[indexPath.section].queryDate
            
            
            if arrInActiveQuery[indexPath.section].image != ""
            {
                let imgURL = arrInActiveQuery[indexPath.section].image!
                cell.imgQuery.setImageFromURl(stringImageUrl: imgURL )
            }
            
            print("image:\(arrInActiveQuery[indexPath.section].image!)")
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)
        
        
        let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "QueryDetailsVC") as! QueryDetailsVC
        
        if cellLoad == "active"
        {
            detailedVC.strQureyID = arrActiveQuery[indexPath.section].id!
        }
        else{
            detailedVC.strQureyID = arrInActiveQuery[indexPath.section].id!

        }
        
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
    


}


class ActiveQueryCell: UITableViewCell {
    @IBOutlet var imgQuery: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblQueryPending: UILabel!

}

class InactiveQueryCell: UITableViewCell {
    @IBOutlet var imgQuery: UIImageView!
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var lblQueryPending: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblTitle: UILabel!
}

class responseActiveQuery
{
    var model : String?
    var id : String?
    var modelYear : String?
    var detailDesc : String?
    var queryDate : String?
    var image : String?
    
    init(model:String, id:String, modelYear:String, detailDesc:String, queryDate:String, image:String)
    {
        self.model = model
        self.id = id
        self.modelYear = modelYear
        self.detailDesc = detailDesc
        self.queryDate = queryDate
        self.image = image
    }
}

class responseInActiveQuery
{
    var model : String?
    var id : String?
    var modelYear : String?
    var detailDesc : String?
    var queryDate : String?
    var image : String?
    
    init(model:String, id:String, modelYear:String, detailDesc:String, queryDate:String, image:String)
    {
        self.model = model
        self.id = id
        self.modelYear = modelYear
        self.detailDesc = detailDesc
        self.queryDate = queryDate
        self.image = image
    }
}

