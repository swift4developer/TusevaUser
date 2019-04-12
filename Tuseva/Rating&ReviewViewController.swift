//
//  Rating&ReviewViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/4/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class Rating_ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(Rating_ReviewViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Rating & Reviews"
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false

    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Reating_ReviewTableViewCell
        
        return cell
        
    }
}

class Reating_ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblProviderName: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var btnStar1: UIButton!
    @IBOutlet var btnStar2: UIButton!
    @IBOutlet var btnStar3: UIButton!
    @IBOutlet var btnStar5: UIButton!
    @IBOutlet var btnStar4: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

