//
//  CustomerDetailsCDViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/9/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit

class CustomerDetailsCDViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollVC: UIView!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var imgCall: UIImageView!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var imgMan: UIImageView!
    
    @IBOutlet var viewButtons: UIView!
    
    @IBOutlet var btnDetails: UIButton!
    @IBOutlet var btnNotes: UIButton!
    @IBOutlet var btnMessage: UIButton!
    
    @IBOutlet var lblSlider: UIImageView!
    
    @IBOutlet var viewDetail: UIView!
    
    @IBOutlet var lblQueryDetail: UILabel!
    @IBOutlet var btnYes: UIButton!
    
    @IBOutlet var lblRequest: UILabel!
    
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblModelName: UILabel!
    @IBOutlet var lblFuleType: UILabel!
    @IBOutlet var lblFuleName: UILabel!
    @IBOutlet var lblVarient: UILabel!
    @IBOutlet var lblVarientName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var viewNote: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var btnAddNotes: UIButton!
    @IBOutlet var viewNoteBottom: UIView!
    @IBOutlet var txtView: UITextView!
    
    @IBOutlet var viewMessage: UIView!
    @IBOutlet var tblMessage: UITableView!
    
    @IBOutlet var viewBottomMsg: UIView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var txtMsg: UITextView!
    @IBOutlet var btnClear: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDetail.isHidden = false
        viewNote.isHidden = true
        viewMessage.isHidden = true
        viewBottomMsg.isHidden = true
    }
    
    @IBAction func btnDetailsClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = btnDetails.frame.origin.x
        lblSlider.frame = frame
        
        viewDetail.isHidden = false
        viewNote.isHidden = true
        viewMessage.isHidden = true
        viewBottomMsg.isHidden = true
    }
    
    @IBAction func btnNotesClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = btnNotes.frame.origin.x
        lblSlider.frame = frame
        
        viewDetail.isHidden = true
        viewNote.isHidden = false
        viewMessage.isHidden = true
        viewBottomMsg.isHidden = true
    }

    @IBAction func btnMessageClk(_ sender: Any)
    {
        var frame: CGRect = lblSlider.frame
        frame.origin.x = btnMessage.frame.origin.x
        lblSlider.frame = frame
        
        viewDetail.isHidden = true
        viewNote.isHidden = true
        viewMessage.isHidden = false
        viewBottomMsg.isHidden = false
        
        tblMessage .reloadData()
    }
    
    @IBAction func btnYesClk(_ sender: Any) {
    }
    
    @IBAction func btnAddNotesClk(_ sender: Any) {
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblView
        {
            return 10;
        }
        else
        {
            return 10;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblView
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "cellNotes", for: indexPath) as! NotesCDTableViewCell
            
            return cell
        }
        else
        {
            if indexPath.row % 2 == 0
            {
                let cell = tblMessage.dequeueReusableCell(withIdentifier: "cellMessage", for: indexPath) as! MessageCDTableViewCell
                
                
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2;
                cell.imgProfile.clipsToBounds = true;
                
                let textViewSize = cell.txtChat.sizeThatFits(CGSize(width: cell.txtChat.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude)))
                
                var frame: CGRect = cell.txtChat.frame
                frame.size.height = textViewSize.height + 10;
                //            frame.size.width = UIScreen.main.bounds.size.width - 38
                cell.txtChat.frame = frame;
                
                
                //            var frameImg:CGRect = cell.imgBubble.frame
                //            frameImg.size.height = cell.chatview.frame.size.height;
                //            cell.imgBubble.frame = frameImg
                
                return cell
                
            }
            else
            {
                let cell = tblMessage.dequeueReusableCell(withIdentifier: "cellMessage1", for: indexPath) as! MessageCDTableViewCell1
                
                cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2;
                cell.imgProfile.clipsToBounds = true;
                
                
                let textViewSize = cell.txtChat.sizeThatFits(CGSize(width: cell.txtChat.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude)))
                
                var frame: CGRect = cell.txtChat.frame
                frame.size.height = textViewSize.height + 10;
                //            frame.size.width = UIScreen.main.bounds.size.width - 38
                cell.txtChat.frame = frame;
                
                //            var frameImg:CGRect = cell.imgBubble.frame
                //            frameImg.size.height = cell.chatView.frame.size.height;
                //            cell.imgBubble.frame = frameImg
                
                return cell
            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblView
        {
            return 100

        }
        else
        {
            if((indexPath.row % 2) == 0)
            {
                let cellIdentifier: String = "cellMessage"
                let cell: MessageCDTableViewCell? = (tblMessage.dequeueReusableCell(withIdentifier: cellIdentifier) as? MessageCDTableViewCell)
                
                
                let textViewSize = cell?.txtChat.sizeThatFits(CGSize(width: (cell?.txtChat.frame.size.width)!, height: CGFloat(FLT_MAX)))
                
                
                return (textViewSize?.height)! + 10
                
            }
            else
            {
                let cellIdentifier: String = "cellMessage1"
                let cell: MessageCDTableViewCell1? = (tblMessage.dequeueReusableCell(withIdentifier: cellIdentifier) as? MessageCDTableViewCell1)
                
                
                let textViewSize = cell?.txtChat.sizeThatFits(CGSize(width: (cell?.txtChat.frame.size.width)!, height: CGFloat(Float.greatestFiniteMagnitude)))
                
                
                
                return (textViewSize?.height)! + 10
                
            }
 
//            return 90
        }
        
    }
    
    
    
    @IBAction func btnSendClk(_ sender: Any) {
    }
    
    @IBAction func btnCameraClk(_ sender: Any) {
    }
    
    @IBAction func btnClearClk(_ sender: Any)
    {
        txtMsg.text = ""
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

class NotesCDTableViewCell: UITableViewCell
{
    @IBOutlet var lblDate: UILabel!    
    @IBOutlet var lblNotes: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
}


class MessageCDTableViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgBubble: UIImageView!
    @IBOutlet var txtChat: UITextView!
    
}

class MessageCDTableViewCell1: UITableViewCell
{
    @IBOutlet var imgBubble: UIImageView!
    @IBOutlet var txtChat: UITextView!
    @IBOutlet var imgProfile: UIImageView!
    
}
