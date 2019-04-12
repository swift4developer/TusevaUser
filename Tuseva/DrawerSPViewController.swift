//
//  DrawerSCViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 05/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DrawerSPViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var name: [String] = ["My Profile", "Dashboard","My Response","My Query","Contact Us","Bookmark Query","Manage Branch","Logout"]
    var image : [UIImage] = [UIImage(named: "profile")!,UIImage(named: "dashboard")!,UIImage(named: "my_response")!,UIImage(named: "my_query")!,UIImage(named: "contact_us")!,UIImage(named: "bookmark")!,UIImage(named: "manage_branch")!,UIImage(named: "logout")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellForDrawer
        cell.lblName.text = name[indexPath.row]
        cell.imgLogo.image = image[indexPath.row]
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        cell.lblBlue.backgroundColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        
        if indexPath.row == 0
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileSP") as? MyProfileSP
            self.navigationController?.pushViewController(profileVC!, animated: true)
        }
        else if indexPath.row == 1
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardCollectionViewController") as? DashboardCollectionViewController
            self.navigationController?.pushViewController(profileVC!, animated: true)
        }
        else if indexPath.row == 2
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyResponseRPSViewController") as? MyResponseRPSViewController
            self.navigationController?.pushViewController(profileVC!, animated: true)
        }
        else if indexPath.row == 3
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyQueryRPSViewController") as? MyQueryRPSViewController
            self.navigationController?.pushViewController(profileVC!, animated: true)

        }
        else if indexPath.row == 4
        {
        
        }
        else if indexPath.row == 5
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyBookmarkRPSViewController") as? MyBookmarkRPSViewController
            self.navigationController?.pushViewController(profileVC!, animated: true)
        }
        else if indexPath.row == 6
        {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageBranchViewController") as? ManageBranchViewController
            self.navigationController?.pushViewController(profileVC!, animated: true)
        }

        else
        {
        
        }
    }
}

class cellForDrawer: UITableViewCell {
    
    @IBOutlet var lblBlue: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgLogo: UIImageView!
}
