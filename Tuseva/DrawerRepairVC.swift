
//
//  DrawerRepairVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 08/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DrawerRepairVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var footerView: UIView!
    var name: [String] = ["My Profile", "Dashboard","My Response","My Query","Contact Us","Bookmark Query"]
    var image : [UIImage] = [UIImage(named: "profile")!,UIImage(named: "dashboard")!,UIImage(named: "my_response")!,UIImage(named: "my_query")!,UIImage(named: "contact_us")!,UIImage(named: "bookmark")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.tableFooterView = footerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellForDrawerRepair
        cell.lblName.text = name[indexPath.row]
        cell.imgLogo.image = image[indexPath.row]
        cell.contentView.backgroundColor = UIColor.white
        cell.lblBlue.backgroundColor = UIColor.white
      
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.contentView.backgroundColor = UIColor.lightGray
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! cellForDrawerRepair
        cell.lblBlue.backgroundColor = UIColor(red:0.04, green:0.53, blue:0.84, alpha:1.0)
        cell.lblName.textColor = UIColor(red:0.04, green:0.53, blue:0.84, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! cellForDrawerRepair
        cell.lblName.textColor = UIColor.black
    }
    
}

class cellForDrawerRepair: UITableViewCell {
    
    @IBOutlet var lblBlue: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgLogo: UIImageView!
}
