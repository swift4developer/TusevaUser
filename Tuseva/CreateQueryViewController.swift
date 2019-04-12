//
//  CreateQueryViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/5/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class CreateQueryViewController: UIViewController {
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var btnQuery: UIButton!
    @IBOutlet var btnMyQuery: UIButton!
    @IBOutlet var lblLine: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollVC: UIView!
    
    @IBOutlet var btnServiceStation: UIButton!
    @IBOutlet var btnSparePart: UIButton!
    @IBOutlet var btnSelectBrand: UIButton!
    @IBOutlet var btnSelectModel: UIButton!
    @IBOutlet var btnSelectYear: UIButton!
    
    @IBOutlet var lblSelectBrand: UILabel!
    @IBOutlet var lblSelectModel: UILabel!
    @IBOutlet var lblSelectYear: UILabel!
    
    @IBOutlet var lblShrotDesc: UILabel!
    @IBOutlet var txtViewShortDesc: UITextView!
    
    @IBOutlet var lblDetailDesc: UILabel!
    @IBOutlet var txtViewDetailDesc: UITextView!
    
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnAddVideo: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var popUp: UIView!
    
    @IBOutlet var imgTick: UIImageView!
    @IBOutlet var lblCongrats: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtViewShortDesc.layer.borderWidth = 1
        txtViewShortDesc.layer.borderColor = UIColor.darkGray.cgColor
        
        txtViewDetailDesc.layer.borderWidth = 1
        txtViewDetailDesc.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(CreateQueryViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Create Query"
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    
    func didTapBackButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }

    
    @IBAction func btnCreateQueryClk(_ sender: Any)
    {
        var frame:CGRect = lblLine.frame
        frame.origin.x = btnQuery.frame.origin.x
        lblLine.frame = frame
    }
    
    @IBAction func btnMyQueryClk(_ sender: Any)
    {
        var frame:CGRect = lblLine.frame
        frame.origin.x = btnMyQuery.frame.origin.x
        lblLine.frame = frame
    }

    @IBAction func btnServiceStationClk(_ sender: Any) {
    }
    
    @IBAction func btnSparePartClk(_ sender: Any) {
    }
    
    @IBAction func btnSelectBrandClk(_ sender: Any) {
    }
    
    @IBAction func btnSelectModelClk(_ sender: Any) {
    }
    
    @IBAction func btnSelectYearClk(_ sender: Any) {
    }
    
    @IBAction func btnAddPhotoClk(_ sender: Any) {
    }
    
    @IBAction func btnAddVideoClk(_ sender: Any) {
    }
    
    @IBAction func btnSubmitClk(_ sender: Any)
    {
        popUpView.isHidden = false
    }
    
    
    @IBAction func btnYesClk(_ sender: Any) {
    }
    
    @IBAction func btnNoClk(_ sender: Any)
    {
        popUpView.isHidden = true
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
