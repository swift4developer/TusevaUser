//
//  DrawerSOViewController.swift
//  Tuseva
//
//  Created by oms183 on 10/25/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DrawerSOViewController: UIViewController {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if UserDefaults.standard.value(forKey: "image") != nil
        {
            let imgURL = UserDefaults.standard.value(forKey: "image") as? String
            self.imgProfile.setImageFromURl(stringImageUrl: imgURL!)
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2;
        imgProfile.clipsToBounds = true
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

class DrawerSOTableViewCell: UITableViewCell {
    
    @IBOutlet var imgQuery: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblBlue: UILabel!
}
