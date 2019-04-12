//
//  QueryDetailSPViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/5/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class QueryDetailSPViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet var collectionVC: UICollectionView!
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var createVC: UIView!
    
    
    @IBOutlet var btnQueryDetail: UIButton!
    @IBOutlet var btnOffer: UIButton!
    @IBOutlet var btnMessage: UIButton!
    @IBOutlet var lblLine: UILabel!
    
    @IBOutlet var offerVC: UIView!
    
    @IBOutlet var messageVC: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var bottomVC: UIView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var btnCamera: UIButton!

    @IBOutlet var txtVC: UIView!
    @IBOutlet var btnClear: UIButton!
    
    @IBOutlet var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(QueryDetailSPViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Query Details"
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func didTapBackButton(sender: AnyObject){
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "revealSP") as? SWRevealViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }

    
    @IBAction func btnQueryDetailClk(_ sender: Any)
    {
        var frame: CGRect = lblLine.frame
        frame.origin.x = btnQueryDetail.frame.origin.x
        lblLine.frame = frame
        
        createVC.isHidden = false
        offerVC.isHidden = true
        messageVC.isHidden = true
        bottomVC.isHidden = true
        
    }
    
    @IBAction func btnOfferClk(_ sender: Any)
    {
        var frame: CGRect = lblLine.frame
        frame.origin.x = btnOffer.frame.origin.x
        lblLine.frame = frame

        createVC.isHidden = true
        offerVC.isHidden = false
        messageVC.isHidden = true
        bottomVC.isHidden = true

    }
    
    @IBAction func btnMessageClk(_ sender: Any)
    {
        var frame: CGRect = lblLine.frame
        frame.origin.x = btnMessage.frame.origin.x
        lblLine.frame = frame
        
        createVC.isHidden = true
        offerVC.isHidden = true
        messageVC.isHidden = false
        bottomVC.isHidden = false


    }
    
    
//     func numberOfSections(in collectionView: UICollectionView) -> Int {
////        return searches.count
//    }
    
    
     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionVC.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! QueryDetailSPCollectionViewCell

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "cellMessage", for: indexPath) as! QueryDetailSPTableViewCell
            
            
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2;
            cell.imgProfile.clipsToBounds = true;
            
            let textViewSize = cell.txtMessage.sizeThatFits(CGSize(width: cell.txtMessage.frame.size.width, height: CGFloat(FLT_MAX)))
            
            var frame: CGRect = cell.txtMessage.frame
            frame.size.height = textViewSize.height + 10;
            cell.txtMessage.frame = frame;
            
            return cell
            
        }
        else
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "cellMessage1", for: indexPath) as! QueryDetailSPTableViewCell1
            
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2;
            cell.imgProfile.clipsToBounds = true;
            
            
            var textViewSize = cell.txtMessage.sizeThatFits(CGSize(width: cell.txtMessage.frame.size.width, height: CGFloat(FLT_MAX)))
            
            var frame: CGRect = cell.txtMessage.frame
            frame.size.height = textViewSize.height + 10;
//            frame.size.width = UIScreen.main.bounds.size.width - 38
            cell.txtMessage.frame = frame;
            
            //            var frameImg:CGRect = cell.imgBubble.frame
            //            frameImg.size.height = cell.chatView.frame.size.height;
            //            cell.imgBubble.frame = frameImg
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //        return 80.0;
        
        
        if((indexPath.row % 2) == 0)
        {
            let cellIdentifier: String = "cellMessage"
            let cell: QueryDetailSPTableViewCell? = (tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? QueryDetailSPTableViewCell)
            
            
            let textViewSize = cell?.txtMessage.sizeThatFits(CGSize(width: (cell?.txtMessage.frame.size.width)!, height: CGFloat(FLT_MAX)))
            
            
            return (textViewSize?.height)! + 10
            
        }
        else
        {
            let cellIdentifier: String = "cellMessage1"
            let cell: QueryDetailSPTableViewCell1? = (tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? QueryDetailSPTableViewCell1)
            
            
            let textViewSize = cell?.txtMessage.sizeThatFits(CGSize(width: (cell?.txtMessage.frame.size.width)!, height: CGFloat(FLT_MAX)))
            
            
            
            return (textViewSize?.height)! + 10
            
        }
        
    }

    
    @IBAction func btnSendClk(_ sender: Any) {
    }
    
    
    @IBAction func btnCameraClk(_ sender: Any) {
    }
    
    @IBAction func btnClearClk(_ sender: Any)
    {
        txtView.text = ""
    }
}

class QueryDetailSPTableViewCell:UITableViewCell
{
    @IBOutlet var imgProfile: UIImageView!
    
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var imgBubble: UIImageView!
}


class QueryDetailSPTableViewCell1:UITableViewCell
{
    @IBOutlet var imgBubble: UIImageView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var imgProfile: UIImageView!
    
}

class QueryDetailSPCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imgCollection: UIImageView!
    
}

