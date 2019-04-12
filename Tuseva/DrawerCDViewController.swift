//
//  DrawerCDViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 09/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DrawerCDViewController: UIViewController {

    @IBOutlet var imgUserIcon: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblUserEmail: UILabel!
    @IBOutlet var footerView: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBAction func btnLogoutClk(_ sender: Any) {
    }
    var name: [String] = ["My Profile", "Leads","Bookmark Leads","Contact Us"]
    var image : [UIImage] = [UIImage(named: "profile")!,UIImage(named: "leads")!,UIImage(named: "b_leads")!,UIImage(named: "contact_us")!]

  
    override func viewDidLoad() {
        super.viewDidLoad()

       tblView.tableFooterView = footerView
    }

}

extension DrawerCDViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellForDrawerCarDealer
        cell.lblName.text = name[indexPath.row]
        cell.imgLogo.image = image[indexPath.row]
        cell.contentView.backgroundColor = UIColor.white
        cell.lblBlue.backgroundColor = UIColor.white

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! cellForDrawerCarDealer
        cell.lblBlue.backgroundColor = UIColor(red:0.04, green:0.53, blue:0.84, alpha:1.0)
        cell.lblName.textColor = UIColor(red:0.04, green:0.53, blue:0.84, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! cellForDrawerCarDealer
        cell.lblName.textColor = UIColor.black
    }
}

class cellForDrawerCarDealer: UITableViewCell {
    
    @IBOutlet var lblBlue: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgLogo: UIImageView!
}
