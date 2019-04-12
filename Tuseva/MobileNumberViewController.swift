//
//  MobileNumberViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/4/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class MobileNumberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        let settingImage = UIImage(named: "setting")
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(MobileNumberViewController.didTapBackButton(sender:)))

        let settingBtn   = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(MobileNumberViewController.didTapSettingButton(sender:)))

        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Mobile Number"
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItem = settingBtn
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }

    func didTapSettingButton(sender: AnyObject){
        
       
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MobileNumberTableViewCell
        
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Rating_ReviewViewController") as! Rating_ReviewViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
//
//    }


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

class MobileNumberTableViewCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
