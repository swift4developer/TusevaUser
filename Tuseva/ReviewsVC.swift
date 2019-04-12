
//
//  ReviewsVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 01/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {

    @IBOutlet var lblBasedOn: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblBadge: UILabel!
    @IBAction func btnReviewsClk(_ sender: Any) {
    }
    @IBAction func btnServiceStationClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var imgArr : [UIImage] = [UIImage(named: "1")!, UIImage(named: "2")!,UIImage(named: "3")!,UIImage(named: "1")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblBadge.layer.cornerRadius = lblBadge.frame.size.height/2
        lblBadge.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // self.view.backgroundColor = UIColor.clear
        
        let navUserImage = UIImage(named: "filled_heart")?.withRenderingMode(.alwaysOriginal)
        let  imgView = UIImageView(image: navUserImage)
        imgView.frame =   CGRect(x: 0, y: 0, width: 28, height: 28)
        
        let leftBtn = UIBarButtonItem.init(customView: imgView)
        
        let backImage = UIImage(named: "backbtn")!
        
        //        let heartBtn = UIBarButtonItem(image: navUserImage, landscapeImagePhone: navUserImage, style: .plain, target: self, action: #selector(ServiceStationNameVC.didTapHeartButton(sender:)))
        
        let backBtn = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ReviewsVC.didTapBackButton(sender:)))
        
        
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
    func didTapHeartButton(sender: AnyObject){
        
        print("Heart btn tapped")
    }

}

extension ReviewsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cell
            
            cell.imgView.image = imgArr[indexPath.row]
             return cell
        }
        
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.textLabel?.text = "View All"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            return cell
        }
    }
}
class cell: UITableViewCell {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
}
