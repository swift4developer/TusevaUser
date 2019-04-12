//
//  QueryDetailViewController.swift
//  SwiftSliderDemo
//
//  Created by oms183 on 8/2/17.
//  Copyright © 2017 oms183. All rights reserved.
//

import UIKit
import Photos
import FirebaseDatabase
import FirebaseStorage
import Alamofire
import MobileCoreServices

class QueryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dbHandler: FIRDatabaseHandle!
    
    @IBOutlet var inputBar: UIView!
    
    var items = [Message]()
    
    var ArrMessages = [messageResponse]()
    
    let imagePicker = UIImagePickerController()
    
    var imageFetch = UIImage()
    
    var isPhoto:String = ""
    
    var videoURL:NSURL?
    var fileURL:String?
    
//    var currentUser: User?
    
    var image = ""
    
    var currentUser: String = ""

    let barHeight: CGFloat = 50
 
    @IBOutlet var topView: UIView!
    
    @IBOutlet var viewButtons: UIView!
    @IBOutlet var imgGarage: UIImageView!
    
    @IBOutlet var btnQueryDetail: UIButton!
    @IBOutlet var btnOffer: UIButton!
    @IBOutlet var btnMessage: UIButton!
    
    @IBOutlet var viewQuery: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewQueryDetail: UIView!
    @IBOutlet var imgQuery: UIImageView!
    @IBOutlet var lblQuery: UILabel!
    
    @IBOutlet var viewDetail: UIView!
    @IBOutlet var lblDetail: UILabel!
    
    @IBOutlet var viewServiceProvider: UIView!
    @IBOutlet var imgServiceProvider: UIImageView!
    @IBOutlet var lblServiceProvider: UILabel!
    
    @IBOutlet var viewProviderDetail: UIView!
    @IBOutlet var lblProviderName: UILabel!    
    @IBOutlet var imgMobile: UIImageView!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblProviderDetail: UILabel!
    
    @IBOutlet var lblSlider: UILabel!
    @IBOutlet var viewBottomMessage: UIView!
    
    @IBOutlet var txtViewMsg: UITextView!
    @IBOutlet var btnClear: UIButton!
    
    @IBOutlet var tblViewMsg: UITableView!
    
    @IBOutlet var btnCamera: UIButton!
    
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var viewOffer: UIView!
    
    @IBOutlet var lblPickUpDesc: UILabel!
    @IBOutlet var lblPickUp: UILabel!
    @IBOutlet var imgPickUp: UIImageView!
    @IBOutlet var lblOfferDesc: UILabel!
    @IBOutlet var lblOffer: UILabel!
    @IBOutlet var imgOffer: UIImageView!
    
    var dictResponse = NSDictionary()

    var actInd = UIActivityIndicatorView()
    
    var strQueryID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        viewQuery.isHidden = false
        tblViewMsg.isHidden = true
        viewBottomMessage.isHidden = true
        viewOffer.isHidden = true
        
        tblViewMsg.delegate = self
        tblViewMsg.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        addToolBar(textField: txtViewMsg)
        
        txtViewMsg.text = "Enter text.."
        
//        tblViewMsg.tableFooterView = viewBottomMessage
        
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(QueryDetailViewController.didTapBackButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title =  "Query Detail"
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        
        let scrollableSize:CGSize = CGSize(width:320, height:scrollView.frame.size.height)
        scrollView.contentSize = scrollableSize
        
        
        self.imagePicker.delegate = self
        self.tblViewMsg.estimatedRowHeight = self.barHeight
        self.tblViewMsg.rowHeight = UITableViewAutomaticDimension
//        self.tblViewMsg.contentInset.bottom = self.barHeight
        self.tblViewMsg.scrollIndicatorInsets.bottom = self.barHeight
        if currentReachabilityStatus != .notReachable
        {
            filldata()
            fetchData()
            
                   }
        else
        {
            alert()
        }
    }
    
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(QueryDetailViewController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Message.markMessagesRead(forUserID: self.currentUser)
    }

    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    
        //Downloads messages
        func fetchData() {
            let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
            let strID:String = "\(strQueryID)_\(self.currentUser)_\(userID)"
            ArrMessages.removeAll()
            DownloadAllMessages(forQueryID: strID, completion: {[weak weakSelf = self] (message) in
                
                weakSelf?.ArrMessages.removeAll()
                weakSelf?.ArrMessages.append(message)
                weakSelf?.ArrMessages.sort{ $0.time < $1.time }
                DispatchQueue.main.async {
                    if (weakSelf?.items.isEmpty) != nil {
                        weakSelf?.tblViewMsg.reloadData()
//                        weakSelf?.tblViewMsg.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                        weakSelf?.tblViewMsg.tableViewScrollToBottom(animated: true)
//                        self.tableView.tableViewScrollToBottom(animated: true)
                    }
                }
            })

            
        }
    
    

    
    func DownloadAllMessages(forQueryID:String, completion: @escaping (messageResponse) -> Swift.Void) {
        
        Constants.MESSAGES_QID = forQueryID
        
            FIRDatabase.database().reference().child(Constants.MESSAGES).child(Constants.MESSAGES_QID).child("chat").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                if let item = snapshot.value
                {
                    print("value item : \(item)")

                    FIRDatabase.database().reference().child(Constants.MESSAGES).child(Constants.MESSAGES_QID).child("chat").observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            
                             let itemMsg = snap.value as! [String: Any]
                            
                                print("value itemMsg : \(itemMsg)")
                                
                                let address = itemMsg["address"] as! String
                                let date = itemMsg["date"] as! String
                                let description = itemMsg["description"] as! String
                                let id = itemMsg["id"] as! String
                                let image = itemMsg["image"] as! String
                                let msg = itemMsg["msg"] as! String
                                let query_id = itemMsg["query_id"] as! String
                                let query_image = itemMsg["query_image"] as! String
                                let receiver_id = itemMsg["receiver_id"] as! String
                                let sender_id = itemMsg["sender_id"] as! String
                                let service_provider_name = itemMsg["service_provider_name"] as! String
                                let time = itemMsg["time"] as! Int
                            let mobile = itemMsg["mobile_no"] as! String
                            let send_image_gallery_camera = itemMsg["send_image_gallery_camera"] as! String
                            let upload_image_video = itemMsg["upload_image_video"] as! String
                                
                            let message = messageResponse.init(address: address, date: date, description: description, id: id, image: image, msg: msg, mobile: mobile, query_id: query_id, query_image: query_image, receiver_id: receiver_id, send_image_gallery_camera: send_image_gallery_camera, sender_id: sender_id, service_provider_name: service_provider_name, time: time, upload_image_video: upload_image_video)
                            
                            completion(message)
                        }
                    })
                    
                    
                }
                    
                   
                }
            })
            
    }

    
    func composeMessage(type: MessageType, content: Any)  {
        
        // store User in FIREBASE DATABASE
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let resultDate = formatter.string(from: date)
        
//        let calendar = Calendar.current
//        
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
//        print("hours = \(hour):\(minutes):\(seconds)")
        
        
        // store messageID in FIREBASE DATABASE
        let userID:String = UserDefaults.standard.value(forKey: "ID") as! String
        let strID:String = "\(strQueryID)_\(self.currentUser)_\(userID)"
        
//        DBProvider.Instance.saveID(withID: strID)
        
        Constants.MESSAGES_QID = strID
        
        Constants.TIME_STAMP = "\(Int(Date().timeIntervalSince1970))"
        
        let uuid = DBProvider.Instance.IdRef
        print(uuid)
        
        let strUuid = "\(uuid)"
        let str = strUuid.characters;
        let indexStr = str.index(of: "-")!
        let indexAfterStr = str.index(after: indexStr)
        
        let strAppend = "-\(strUuid[indexAfterStr..<strUuid.endIndex])"
        
        
        print(strAppend)
        
        let imageUser = UserDefaults.standard.value(forKey: "image") as! String
        
        let mobile = UserDefaults.standard.value(forKey: "mobile") as! String
                
        
        
        switch type {
            
        case .photo:
            
            DBProvider.Instance.saveMessage(withID: "\(strAppend)", address: lblAddress.text!, date: resultDate, description: lblDetail.text!, id: userID, image: imageUser, mobile_no: mobile, msg: "", profile_image: imageUser, query_id: strQueryID, query_image: image, receiver_id: self.currentUser, send_image_gallery_camera: "", sender_id: userID, service_provider_name: lblProviderName.text!, time: Int(Date().timeIntervalSince1970), upload_image_video: content as! String)
            
        case .text:
            
            DBProvider.Instance.saveMessage(withID: "\(strAppend)", address: lblAddress.text!, date: resultDate, description: lblDetail.text!, id: userID, image: imageUser, mobile_no: mobile, msg: content as! String, profile_image:imageUser, query_id: strQueryID, query_image: image, receiver_id: self.currentUser, send_image_gallery_camera: "", sender_id: userID, service_provider_name: lblProviderName.text!, time: Int(Date().timeIntervalSince1970), upload_image_video: "")
            
        default:
            break
        }

    }

    
    func filldata()
    {
        lblDetail.text = dictResponse.value(forKey: "detail_description") as? String
        lblProviderName.text = dictResponse.value(forKey: "name") as? String
        lblMobileNo.text = dictResponse.value(forKey: "mobile") as? String
        
        let strLocation = dictResponse.value(forKey: "location") as? String
        let strCity = dictResponse.value(forKey: "city") as? String
        lblAddress.text = "\(strLocation!),\(strCity!)"
        
        lblProviderDetail.text = dictResponse.value(forKey: "short_description") as? String
        
        
//        if let arrImage = dictResponse.value(forKey:  "image") as? [AnyObject]
//        {
//            for arrImgData in arrImage
//            {
//                image = (arrImgData["image"] as? String)!
//                
//                break
//            }
//        }
//        else
//        {
//            image = ""
//        }
//        
//        self.imgGarage.setImageFromURl(stringImageUrl: image)
        
        image = dictResponse.value(forKey: "image") as! String
        
        self.imgGarage.setImageFromURl(stringImageUrl: image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnQueryDetailClk(_ sender: Any)
    {
        var frame:CGRect = lblSlider.frame
        frame.origin.x = btnQueryDetail.frame.origin.x
        lblSlider.frame = frame
        
        viewQuery.isHidden = false
        tblViewMsg.isHidden = true
        viewBottomMessage.isHidden = true
        viewOffer.isHidden = true
    }
    
    @IBAction func btnOfferClk(_ sender: Any)
    {
        var frame:CGRect = lblSlider.frame
        frame.origin.x = btnOffer.frame.origin.x
        lblSlider.frame = frame
        
        viewQuery.isHidden = true
        tblViewMsg.isHidden = true
        viewBottomMessage.isHidden = true
        viewOffer.isHidden = false
        
        if currentReachabilityStatus != .notReachable
        {
            loginCheck(isActive: "")
//            offer()
        }
        else
        {
            alert()
        }
    }
    
    func loginCheck(isActive:String)  {
        
        let id:String = UserDefaults.standard.value(forKey: "ID") as! String
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=logincheck&user_id=\(id)")!
        
        print("URL>\(url)")
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    
                    if responseCode == 0
                    {
                        let message = resJson.value(forKey:  "RESPONSE") as? String
                        
                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else if responseCode == 1
                    {
                        print("Success")
                        
                        if isActive == "1"
                        {
                            self.upload()
                        }
                        else
                        {
                            self.offer()
                        }
                        
                    }
                }
            }
            else if response.result.isFailure
            {
                
                if let error = response.result.error
                {
                    print("Response Error \(error.localizedDescription)")
                    
                }
                
            }
        }
    }

    
    func offer()
    {
        actInd.startAnimating()
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=offer_for_query&query_id=\(strQueryID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
                    {
                        var message : String?
                        if responseCode == 0
                        {
                            message = resJson.value(forKey:  "RESPONSE") as? String
                            
                            let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                self.actInd.stopAnimating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else if responseCode == 1
                        {
                            
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? NSDictionary
                            {
                                if (resValue.value(forKey: "offer") as! String) == ""
                                {
                                    self.lblOfferDesc.text = resValue.value(forKey: "offer") as? String
                                }
                                else
                                {
                                    self.lblOfferDesc.text = "Get \(resValue.value(forKey: "offer") as! String)% Off on first paid service"
                                }
                                
                                if (resValue.value(forKey: "pickup_amount") as! String) == ""
                                {
                                    self.lblPickUpDesc.text = resValue.value(forKey: "pickup_amount") as? String
                                }
                                else
                                {
                                    self.lblPickUpDesc.text = "Explore your pickup service just Rs \(resValue.value(forKey: "pickup_amount") as! String)"
                                }
                               
                            }
                            self.actInd.stopAnimating()
                        }
                    }
                }
            }
            else if response.result.isFailure
            {
                print("Response Error")
                self.actInd.stopAnimating()
            }
        }
    }
    
    
    @IBAction func btnMessageClk(_ sender: Any)
    {
        var frame:CGRect = lblSlider.frame
        frame.origin.x = btnMessage.frame.origin.x
        lblSlider.frame = frame
        
        viewQuery.isHidden = true
        tblViewMsg.isHidden = false
        viewBottomMessage.isHidden = false
        viewOffer.isHidden = true
    }
    
    @IBAction func btnSendClk(_ sender: Any) {
        if let text = self.txtViewMsg.text {
            if text.characters.count > 0 {
                self.composeMessage(type: .text, content: self.txtViewMsg.text!)
                self.txtViewMsg.text = "Enter text.."
            }
        }

    }
    
    @IBAction func btnCameraClk(_ sender: Any)
    {
//        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//        if (status == .authorized || status == .notDetermined) {
//            self.imagePicker.sourceType = .camera
//            self.imagePicker.allowsEditing = false
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie","public.image"]
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
//        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.composeMessage(type: .photo, content: pickedImage)
//        } else {
//            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            self.composeMessage(type: .photo, content: pickedImage)
//        }
//        picker.dismiss(animated: true, completion: nil)
        
        var  chosenImage = UIImage()
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType == kUTTypeImage {
            
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            
            imageFetch = chosenImage
            
            loginCheck(isActive: "1")
//            upload()
            
            dismiss(animated:true, completion: nil) //5
            
        }
            
        else {
            
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            if let fileURL =  info[UIImagePickerControllerMediaURL] as? URL {
                do {
                    try  FileManager.default.moveItem(at: fileURL, to: documentsDirectoryURL.appendingPathComponent("videoName").appendingPathExtension("mov"))
                    print("movie saved")
                } catch {
                    print(error)
                }
                
                self.videoURL = fileURL as NSURL
                
                print("URL>>\(self.videoURL!)")
            }
            
            self.imageFetch = self.videoPreviewUiimage(vidURL: self.videoURL! as URL)!
            
            self.imagePicker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func videoPreviewUiimage(vidURL:URL) -> UIImage? {
        //        let filePath = NSString(string: "~/").expandingTildeInPath.appending("/Documents/").appending(fileName)
        //
        //        let vidURL = NSURL(fileURLWithPath:filePath)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func upload()
    {
        actInd.startAnimating()
        
        let image = imageFetch
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let id:String = (UserDefaults.standard.value(forKey: "ID")! as? String)!
        
        let parameters = ["user_id" : "\(id)"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=upload_chat_files")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("Req>> \(response.request!)")  // original URL request
                    print("Res>> \(response.response!)") // URL response
                    print("Data>> \(response.data!)")     // server data
                    print("Result>> \(response.result)")   // result of response serialization
                    
                    let json = response.result.value as! NSDictionary
                    
                    print("JSON >> \(json)")
                    
                    let resCode = json.value(forKey: "RESPONSECODE") as? Int
                    
                    if resCode == 1
                    {
                        if let responseData = json.value(forKey: "RESPONSE") as? NSDictionary {
                            
                            let file_id = responseData.value(forKey: "file_id") as? Int
                            print(file_id!)
                            
                            self.fileURL = responseData.value(forKey: "file") as? String
                            
                            self.composeMessage(type: .photo, content: self.fileURL!)
                        }
                        
                    }
                    else
                    {
                        print("Failed to upload")
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.actInd.stopAnimating()
                        
                        //  self.imgUser.setImageFromURl(stringImageUrl: "\(json.value(forKey: "RESPONSEIMG") as? String ?? "userImage")");
                    });
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
        
    
    
    
    @IBAction func btnClearClk(_ sender: Any)
        
    {
        txtViewMsg.text = "Enter text.."
    }
    
    //MARK: NotificationCenter handlers
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tblViewMsg.contentInset.bottom = height
            self.tblViewMsg.scrollIndicatorInsets.bottom = height
            if self.ArrMessages.count > 0 {
                self.tblViewMsg.scrollToRow(at: IndexPath.init(row: self.ArrMessages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }

    

    //MARK: TableView Delegates

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tblViewMsg.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch self.items[indexPath.row].owner {
//        case .receiver:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//            cell.clearCellData()
//            switch self.items[indexPath.row].type {
//            case .text:
//                cell.message.text = self.items[indexPath.row].content as! String
//            case .photo:
//                if let image = self.items[indexPath.row].image {
//                    cell.messageBackground.image = image
//                    cell.message.isHidden = true
//                } else {
//                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
//                        if state == true {
//                            DispatchQueue.main.async {
//                                self.tblViewMsg.reloadData()
//                            }
//                        }
//                    })
//                }
//            case .location:
//                cell.messageBackground.image = UIImage.init(named: "location")
//                cell.message.isHidden = true
//            }
//            return cell
//        case .sender:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//            cell.clearCellData()
////            cell.profilePic.image = self.currentUser?.profilePic
//            switch self.items[indexPath.row].type {
//            case .text:
//                cell.message.text = self.items[indexPath.row].content as! String
//            case .photo:
//                if let image = self.items[indexPath.row].image {
//                    cell.messageBackground.image = image
//                    cell.message.isHidden = true
//                } else {
//                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
//                        if state == true {
//                            DispatchQueue.main.async {
//                                self.tblViewMsg.reloadData()
//                            }
//                        }
//                    })
//                }
//            case .location:
//                cell.messageBackground.image = UIImage.init(named: "location")
//                cell.message.isHidden = true
//            }
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.inputTextField.resignFirstResponder()
//        switch self.items[indexPath.row].type {
//        case .photo:
//            if let photo = self.items[indexPath.row].image {
//                let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//                self.inputAccessoryView?.isHidden = true
//            }
//        case .location:
//            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
//            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
//            let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//            self.inputAccessoryView?.isHidden = true
//        default: break
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id : String = ArrMessages[indexPath.row].id!
        
        if id == UserDefaults.standard.value(forKey: "ID") as! String {
            
            let cell = tblViewMsg.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell

            
            cell.clearCellData()
//            cell.message.text = ArrMessages[indexPath.row].msg!
//            
//            cell.messageBackground.image = UIImage(named: "Chat_BubbleSub")
            
            
            if ArrMessages[indexPath.row].msg! == ""
            {
                cell.messageBackground.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].upload_image_video!)
                
//                cell.profileImage.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].image!)
            }
            else
            {
                cell.message.text = ArrMessages[indexPath.row].msg!
                
                cell.messageBackground.image = UIImage(named: "Chat_BubbleSub")
                
//                cell.profileImage.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].image!)
            }

            
            return cell
        }
        
        else
        {
            let cell = tblViewMsg.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            
            
            cell.clearCellData()
//            cell.message.text = ArrMessages[indexPath.row].msg!
//            
//            cell.messageBackground.image = UIImage(named: "Chat_bubble")
//            cell.profilePic.image = UIImage(named: "user")
            
            
            if ArrMessages[indexPath.row].msg! == ""
            {
                cell.messageBackground.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].upload_image_video!)
                
                cell.profilePic.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].image!)
            }
            else
            {
                cell.message.text = ArrMessages[indexPath.row].msg!
                
                cell.messageBackground.image = UIImage(named: "Chat_bubble")
                
                cell.profilePic.setImageFromURl(stringImageUrl: ArrMessages[indexPath.row].image!)
            }

            
            
            return cell

        }
        

        
//        switch self.items[indexPath.row].owner {
//            case .receiver:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//            return cell
//        case .sender:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//            
//            return cell
//        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
////        return 90
//        
//        let id : String = ArrMessages[indexPath.row].id!
//        
//        if id == UserDefaults.standard.value(forKey: "ID") as! String {
//            
////                let cell = tblViewMsg.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//            
//            
//                let textViewSize = cell.message.sizeThatFits(CGSize(width: (cell.message.frame.size.width), height: CGFloat(FLT_MAX)))
//                
//                
//                return (textViewSize.height) + 10
//                
//            }
//            else
//            {
////                let cell = tblViewMsg.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//                
//                
//                let textViewSize = cell.message.sizeThatFits(CGSize(width: (cell.message.frame.size.width), height: CGFloat(FLT_MAX)))
//                
//                
//                
//                return (textViewSize.height) + 10
//                
//            }
//
//    }

    
    
    
}

class MsgTblViewCell : UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgBubble: UIImageView!
    @IBOutlet var txtChat: UITextView!
    
}

class Msg2TblViewCell: UITableViewCell
{
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgBubble: UIImageView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var txtChat: UITextView!
    
}


class messageResponse
{
    var address: String?
    var date: String?
    var description: String?
    var id: String?
    var image: String?
    var mobile: String?
    var msg: String?
    var query_id: String?
    var query_image: String?
    var receiver_id: String?
    var send_image_gallery_camera: String?
    var sender_id: String?
    var service_provider_name: String?
    var time: Int
    var upload_image_video:String?
    
    init(address:String, date:String, description:String, id:String, image:String, msg:String, mobile: String, query_id:String, query_image:String, receiver_id:String, send_image_gallery_camera: String, sender_id:String, service_provider_name: String, time:Int, upload_image_video:String)
    {
        self.address = address
        self.date = date
        self.description = description
        self.id = id
        self.image = image
        self.msg = msg
        self.mobile = mobile
        self.query_id = query_id
        self.query_image = query_image
        self.receiver_id = receiver_id
        self.send_image_gallery_camera = send_image_gallery_camera
        self.sender_id = sender_id
        self.service_provider_name = service_provider_name
        self.time = time
        self.upload_image_video = upload_image_video

    }
}



extension QueryDetailViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(QueryDetailViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QueryDetailViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtViewMsg.delegate = self
        txtViewMsg.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtViewMsg.text == "Enter text.."
        {
            txtViewMsg.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtViewMsg.text == ""
        {
            txtViewMsg.text = "Enter text.."
        }
    }
    
}

extension UITableView {
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        }
    }
}
