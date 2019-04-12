//
//  PopUpCallVC2.swift
//  Tuseva
//
//  Created by Praveen Khare on 02/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class PopUpCallVC2: UIViewController {

    @IBOutlet var btnCall: UIButton!
    
    @IBAction func btnCallClicked(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)

    }
    func handleTap() {
        self.view.removeFromSuperview()
    }
}
