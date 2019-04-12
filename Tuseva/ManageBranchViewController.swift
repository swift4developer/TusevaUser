//
//  ManageBranchViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/4/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class ManageBranchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false

        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ManageBranchViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Manage Branch"
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func didTapBackButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }

    @IBAction func btnFabClk(_ sender: Any)
    {
        let addBranchVC = self.storyboard?.instantiateViewController(withIdentifier: "ADD_BranchVC") as! ADD_BranchVC
        self.navigationController?.pushViewController(addBranchVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageBranchTableViewCell
        
        return cell
        
    }

}

class ManageBranchTableViewCell: UITableViewCell {
    
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var lblServiceStationName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnMainBranch: UIButton!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var imgMobile: UIImageView!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

