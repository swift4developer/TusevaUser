
//  PopUpViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 26/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBAction func btnOkClk(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
    }

    func handleTap() {
        self.view.removeFromSuperview()
    }
}
