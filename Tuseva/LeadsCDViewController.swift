//
//  LeadsCDViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/9/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class LeadsCDViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cellLeads", for: indexPath) as! LeadsCDTableViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
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

class LeadsCDTableViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var imgCall: UIImageView!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var lblDetail: UILabel!
    
}
