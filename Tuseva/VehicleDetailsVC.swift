//
//  VehicleDetailsVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 04/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class VehicleDetailsVC: UIViewController {

    var wheelerTableView = UITableView()
    var brandTableView = UITableView()
    var serviceTableView = UITableView()
    
    var wheelers:[String] = ["Two Wheeler","Four Wheeler"]
    var brands:[String] = ["Maruti Suzuki","Hyundai","Ford"]
    var service:[String] = ["Service 1","Service 2","Service 3"]
    
    @IBOutlet var viewHeight: NSLayoutConstraint!
    @IBOutlet var verticalToButton: NSLayoutConstraint!
    @IBOutlet var verrical3: NSLayoutConstraint!
    @IBOutlet var vertical2: NSLayoutConstraint!
    @IBOutlet var vertical1: NSLayoutConstraint!
    @IBOutlet var detailedView: UIView!
    @IBOutlet var serviceView: UIView!
    @IBOutlet var brandView: UIView!
    @IBOutlet var wheelerView: UIView!
    @IBOutlet var lblSelectWheeler: UILabel!
    
    
    @IBOutlet var btnRequest: UIButton!
    
    @IBOutlet var lblSelectBrand: UILabel!
    @IBOutlet var lblSelectService: UILabel!

    
    @IBAction func btnRequestClk(_ sender: Any) {
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MobileNumberViewController") as! MobileNumberViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
//        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DrawerSCViewController") as! DrawerSCViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    
    @IBAction func btnWheelerClk(_ sender: Any) {
        brandTableView.isHidden = true
        serviceTableView.isHidden = true
        
        if (wheelerTableView.isHidden == true ) {
            wheelerTableView.isHidden = false
            
            var frame : CGRect = detailedView.frame
            frame.size.height = 218 + 100
            detailedView.frame = frame
            
            vertical1.constant = 100
            verrical3.constant = 10
            vertical2.constant = 10
            verticalToButton.constant = verticalToButton.constant - 100
            wheelerTableView.frame = CGRect(x: self.wheelerView.frame.origin.x , y:  self.wheelerView.frame.origin.y + self.wheelerView.frame.size.height, width: self.wheelerView.frame.size.width, height: 100)
           
            self.detailedView.addSubview(wheelerTableView)
        }
        else
        {
            wheelerTableView.isHidden = true
            vertical1.constant = 10
            verticalToButton.constant = 160
            
            var frame : CGRect = detailedView.frame
            frame.size.height = 218
            detailedView.frame = frame
        }

    }
    @IBAction func btnBrandClk(_ sender: Any) {
        wheelerTableView.isHidden = true
        serviceTableView.isHidden = true
        
        if (brandTableView.isHidden == true ) {
            vertical2.constant = 150
            vertical1.constant = 10
            verrical3.constant = 10
            var frame : CGRect = detailedView.frame
            frame.size.height = 218 + 150
            detailedView.frame = frame
            verticalToButton.constant = verticalToButton.constant - 150
             brandTableView.isHidden = false
            brandTableView.frame = CGRect(x: self.brandView.frame.origin.x , y:  108, width: self.brandView.frame.size.width, height: 150)
            self.detailedView.addSubview(brandTableView)
        }
        else
        {
            brandTableView.isHidden = true
            vertical2.constant = 10
            verticalToButton.constant = 160
            
            var frame : CGRect = detailedView.frame
            frame.size.height = 218
            detailedView.frame = frame
        }
    }
    
    @IBAction func btnServiceClk(_ sender: Any) {
        brandTableView.isHidden = true
        wheelerTableView.isHidden = true
        
        if (serviceTableView.isHidden == true ) {
            
            verrical3.constant = 150
            vertical1.constant = 10
            vertical2.constant = 10
            var frame : CGRect = detailedView.frame
            frame.size.height = 218 + 150
            detailedView.frame = frame
            verticalToButton.constant = verticalToButton.constant - 150
            serviceTableView.isHidden = false
            serviceTableView.frame = CGRect(x: self.serviceView.frame.origin.x , y:  163, width: self.serviceView.frame.size.width, height: 150)
            self.detailedView.addSubview(serviceTableView)
        }
        else
        {
            serviceTableView.isHidden = true
            verrical3.constant = 10
            verticalToButton.constant = 160
            
            var frame : CGRect = detailedView.frame
            frame.size.height = 218
            detailedView.frame = frame
        }
    }
    
    
    @IBAction func btnAlreadyRegister(_ sender: Any)
    {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginSP") as! LoginSP
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.btnRequest.layer.cornerRadius = self.btnRequest.frame.height/2.0;
        self.navigationController?.navigationBar.isHidden = true
        
        wheelerTableView.isHidden = true
        
        wheelerTableView.delegate = self
        wheelerTableView.dataSource = self
        
        wheelerTableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
     
        brandTableView.isHidden = true
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        
        brandTableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        
        serviceTableView.isHidden = true
        
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        serviceTableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        
        detailedView.bringSubview(toFront: btnRequest)
        hideKeyboardWhenTappedAround()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = true
    }
}

extension VehicleDetailsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == wheelerTableView {
            return wheelers.count
        }
        else if tableView == brandTableView{
            return brands.count
        } else {
            return service.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == wheelerTableView {
            let cell = wheelerTableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerCell
            cell?.lblName.text = wheelers[indexPath.row]
            
            return cell!
        }else if tableView == brandTableView {
            let cell = brandTableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerCell
            cell?.lblName.text = brands[indexPath.row]
            
            return cell!
        }
        else {
            let cell = serviceTableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerCell
            cell?.lblName.text = service[indexPath.row]
            
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == wheelerTableView {
            wheelerTableView.isHidden = true
            vertical1.constant = 10
            verticalToButton.constant = 120
        }
        else if tableView == brandTableView {
            brandTableView.isHidden = true
            vertical2.constant = 10
            verticalToButton.constant = 120
        }
        else {
            serviceTableView.isHidden = true
            verrical3.constant = 10
            verticalToButton.constant = 120
        }
    }
}
