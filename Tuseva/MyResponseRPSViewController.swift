//
//  MyResponseRPSViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/8/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class MyResponseRPSViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false

        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(MyResponseRPSViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "My Response"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cellMyResponse", for: indexPath) as! MyResponseRPSTableViewCell
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 92
    }


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

class MyResponseRPSTableViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDisable: UILabel!
    @IBOutlet var imgRed: UIImageView!
    
    @IBOutlet var btnStar: UIButton!
}
