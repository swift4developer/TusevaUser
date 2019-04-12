//
//  PopUpShareContact.swift
//  Tuseva
//
//  Created by Praveen Khare on 29/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class PopUpShareContact: UIViewController {

    var barTitle:String = ""
    
    var repairType:String = ""
    var desc:String = ""
    var videoURL = NSURL()
    var image:UIImage?
    var isImage:String = ""
    var isVideo:String = ""
    
    var shareContact:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    func handleTap() {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnShareClk(_ sender: Any) {
        
        
        gotoNext(shareCnt: "1")
        
//        let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
//        self.navigationController?.pushViewController(dashVC, animated: true)

    }

    @IBAction func btnDontShareClk(_ sender: Any) {
        gotoNext(shareCnt: "1")
    }
    
    func gotoNext(shareCnt:String)
    {
        let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "feature") as? FeaturedPopUp
//        self.switchValue = true
        var frame: CGRect = popAdVC!.view.frame;
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        popAdVC?.view.frame = frame;
        
        popAdVC?.repairType = repairType
        popAdVC?.desc = desc
        popAdVC?.image = image
        popAdVC?.videoURL = self.videoURL
        popAdVC?.isImage = self.isImage
        popAdVC?.isVideo = self.isVideo
        popAdVC?.shareContact = shareCnt
        
        self.addChildViewController(popAdVC!)
        self.view.addSubview((popAdVC?.view)!)
        popAdVC?.didMove(toParentViewController: self)
    }

}
