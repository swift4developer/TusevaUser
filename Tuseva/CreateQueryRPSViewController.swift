//
//  CreateQueryRPSViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/8/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class CreateQueryRPSViewController: UIViewController {
    
    @IBOutlet var viewTop: UIView!
    
    @IBOutlet var btnCreateQuery: UIButton!
    @IBOutlet var btnMyQuery: UIButton!
    
    @IBOutlet var lblSlider: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollVC: UIView!
    
    @IBOutlet var txtShortDesc: UITextView!
    @IBOutlet var txtLongDesc: UITextView!
    
    @IBOutlet var btnSwitch: UISwitch!
    
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnAddVideo: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var popVC: UIView!
    @IBOutlet var imgTick: UIImageView!
    @IBOutlet var lblCongrats: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var btnOk: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        txtShortDesc.layer.borderWidth = 1
        txtShortDesc.layer.borderColor = UIColor.darkGray.cgColor
        
        txtLongDesc.layer.borderWidth = 1
        txtLongDesc.layer.borderColor = UIColor.darkGray.cgColor
        
        popUpView.isHidden = true
    }

    @IBAction func btnCreateQueryClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = 0
        lblSlider.frame = frame
    }
    
    @IBAction func btnMyQueryClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = btnMyQuery.frame.origin.x
        lblSlider.frame = frame
    }
    
    @IBAction func btnAddPhotoClk(_ sender: Any) {
    }
    
    @IBAction func btnAddVideoClk(_ sender: Any) {
    }
    
    @IBAction func btnSubmitClk(_ sender: Any)
    {
        popUpView.isHidden = false
    }
    
    
    @IBAction func btnOkClk(_ sender: Any)
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
