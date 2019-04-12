//
//  MyQueryRPSViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/8/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class MyQueryRPSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var viewTop: UIView!
    
    @IBOutlet var btnNewQuery: UIButton!
    @IBOutlet var btnExistingQuery: UIButton!
    @IBOutlet var lblSlider: UILabel!
    
    @IBOutlet var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(MyQueryRPSViewController.didTapBackButton(sender:)))

        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "My Query"
    
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
    
    
    @IBAction func btnNewQueryClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = 0
        lblSlider.frame = frame
    }
    
    @IBAction func btnExistingQueryClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = btnExistingQuery.frame.origin.x
        lblSlider.frame = frame
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cellRPS", for: indexPath) as! MyQueryRPSTableViewCell
        
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

class MyQueryRPSTableViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDetail: UILabel!
}
