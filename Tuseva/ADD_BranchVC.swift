//
//  ADD_BranchVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 05/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class ADD_BranchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(ADD_BranchVC.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Add Branch"
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }


}
