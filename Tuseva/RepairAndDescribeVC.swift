
//
//  RepairAndDescribeVC.swift
//  Tuseva
//
//  Created by Praveen Khare on 28/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class RepairAndDescribeVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var barTitle:String = ""
    var switchValue: Bool = false
    var fuelTableView = UITableView()
//    var fuelType: [String] = ["Service", "Washing","Engine work","Oil change","Damage service"]
    
    @IBOutlet var lblRepairType: UILabel!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var repairView: UIView!
    @IBOutlet var addSwitch: UISwitch!
    
    var isPhoto:String = ""
    
    var strOTP:String = ""
    var strQueryID:String = ""
    
    var isImage:String = ""
    var isVideo:String = ""
    
    let picker = UIImagePickerController()
    
    let imagePickerController = UIImagePickerController()
//    var videoURL: NSURL? = nil
    
    var videoURL = NSURL()
    var image:UIImage?
    
    var videoData = NSData()
    
    var selectRepairType = [responseArrayRepairService]()
    
    var strRepairTypeID:String = ""
    
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        actInd.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        actInd.color = UIColor.black
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        
        descTextView.text = "Please describe issue.."
        descTextView.layer.borderWidth = 1
        descTextView.layer.borderColor = UIColor.gray.cgColor
        descTextView.layer.cornerRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addToolBar(textField: descTextView)
        
        let settingImage   = UIImage(named: "setting")!
        let backImage = UIImage(named: "backbtn")!
        
        let backBtn   = UIBarButtonItem(image: backImage, landscapeImagePhone: backImage, style: .plain, target: self, action: #selector(RepairAndDescribeVC.didTapBackButton(sender:)))
        
        let settingBtn = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(RepairAndDescribeVC.didTapSettingButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = barTitle
        self.navigationItem.rightBarButtonItem = settingBtn
        self.navigationItem.leftBarButtonItem = backBtn
        
        fuelTableView.isHidden = true
        
        fuelTableView.delegate = self
        fuelTableView.dataSource = self
        
        fuelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        if currentReachabilityStatus != .notReachable
        {
//            loginCheck(isActive: "")
            serviceRepair()
        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
//        if isPopUp == "1"
//        {
//            addSwitch.setOn(false, animated: true)
//        }
//        else
//        {
//            
//        }
    }
    
    
    func didTapBackButton(sender: AnyObject){
        
        self.navigationController?.popViewController(animated: true)
    }
    func didTapSettingButton(sender: AnyObject){
        
        print("Setting btn tapped")
    }

//    func loginCheck(isActive:String)  {
//        
//        let id:String = UserDefaults.standard.value(forKey: "ID") as! String
//        
//        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=logincheck&user_id=\(id)")!
//        
//        print("URL>\(url)")
//        
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            
//            if response.result.isSuccess
//            {
//                if let resJson = response.result.value as? NSDictionary
//                {
//                    let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int
//                    
//                    if responseCode == 0
//                    {
//                        let message = resJson.value(forKey:  "RESPONSE") as? String
//                        
//                        let alert = UIAlertController(title: "Tuseva", message: message, preferredStyle: .alert)
//                        
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
//                            
//                            
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    else if responseCode == 1
//                    {
//                        print("Success")
//                        
////                        if isActive == "1"
////                        {
////                            self.modelType()
////                        }
////                        else if isActive == "2"
////                        {
////                            self.varientType()
////                        }
////                        else
////                        {
//                            self.serviceRepair()
////                        }
//                        
//                    }
//                }
//            }
//            else if response.result.isFailure
//            {
//                
//                if let error = response.result.error
//                {
//                    print("Response Error \(error.localizedDescription)")
//                    
//                }
//                
//            }
//        }
//    }

    
    @IBAction func btnRepairClk(_ sender: Any)
    {
        if (fuelTableView.isHidden == true ) {
            fuelTableView.isHidden = false
            fuelTableView.frame = CGRect(x: self.repairView.frame.origin.x , y:  self.repairView.frame.origin.y + self.repairView.frame.size.height, width: self.repairView.frame.size.width, height: 180)
            fuelTableView.estimatedRowHeight = 60
            self.view.addSubview(fuelTableView)
        }
        else
        {
            fuelTableView.isHidden = true
        }
    }
    
    func serviceRepair()
    {
        actInd.startAnimating()
        let strVehicleID:String = UserDefaults.standard.value(forKey: "VehicleIDService") as! String
        
        let newString: String = "http://omsoftware.us/overachievers/tuseva_service/webservices.php?action=select_repair_type&vehicle_type=\(strVehicleID)".replacingOccurrences(of: " ", with: "%20")
        
        let url : URLConvertible = URL(string: newString )!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("RESPONSE>>>>>>\(response)")
            
            if response.result.isSuccess
            {
                if let resJson = response.result.value as? NSDictionary
                {
                    self.selectRepairType.removeAll()
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
                            if let resValue = resJson.value(forKey:  "RESPONSE") as? [AnyObject]
                            {
                                for arrData in resValue {
                                    
                                    guard let repair_type = arrData["repair_type"] as? String
                                        else
                                    {
                                        return
                                    }
                                    let id = arrData["id"] as? String
                                    print("ID>>>\(id!)")
                                    let r = responseArrayRepairService(repairType:repair_type, repairID:id!)
                                    
                                    self.selectRepairType.append(r)
                                }
                                
                                DispatchQueue.main.async(execute: {
                                    self.fuelTableView.reloadData()
                                    self.actInd.stopAnimating()
                                })
                            }
                            
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
    
    
    @IBAction func btnAddPhotoClk(_ sender: Any)
    {
        isPhoto = "1"

        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Gallary", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            self.picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            
        })
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            } else {
                self.noCamera()
            }
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    
    
    @IBAction func btnAddViewClk(_ sender: Any)
    {
        isPhoto = "0"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if isPhoto == "1"
        {
            var  chosenImage = UIImage()
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            
            image = chosenImage
            
            print(image!)
            
            isImage = "1"
//            imgUserIcon.image = chosenImage //4
            dismiss(animated:true, completion: nil) //5
        }
        else
        {
//            videoURL = (info["UIImagePickerControllerReferenceURL"] as? NSURL)!
//            print("video:\(videoURL)")
//            
//             print("video: \(videoURL.relativePath!)")
            
            
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            if let fileURL =  info[UIImagePickerControllerMediaURL] as? URL {
                do {
                    try  FileManager.default.moveItem(at: fileURL, to: documentsDirectoryURL.appendingPathComponent("videoName").appendingPathExtension("mov"))
                    print("movie saved")
                } catch {
                    print(error)
                }
                isVideo = "1"
                videoURL = fileURL as NSURL
            }

            imagePickerController.dismiss(animated: true, completion: nil)

            
        }

    }
    
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
  
    @IBAction func btnSendClk(_ sender: Any)
    {
        validation()
    }
    
    func validation()
    {
        if lblRepairType.text == "Repair Type"
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please select repair type", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if descTextView.text == "Please describe issue.."
        {
            let alert = UIAlertController(title: "Tuseva", message: "Please describe issue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "contact") as? PopUpShareContact
            self.switchValue = true
            var frame: CGRect = popAdVC!.view.frame;
            frame.size.width = UIScreen.main.bounds.size.width
            frame.size.height = UIScreen.main.bounds.size.height
            popAdVC?.view.frame = frame;
            
            popAdVC?.repairType = lblRepairType.text!
            popAdVC?.desc = descTextView.text!
            popAdVC?.image = self.image
            popAdVC?.videoURL = self.videoURL
            popAdVC?.isImage = self.isImage
            popAdVC?.isVideo = self.isVideo

            self.addChildViewController(popAdVC!)
            self.view.addSubview((popAdVC?.view)!)
            popAdVC?.didMove(toParentViewController: self)
            
        }
    }
    

    
    func gotoNextVC()
    {
        if currentReachabilityStatus != .notReachable
        {
            let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "verify") as? PopUpVerifyVC
            
            var frame: CGRect = popAdVC!.view.frame;
            frame.size.width = UIScreen.main.bounds.size.width
            frame.size.height = UIScreen.main.bounds.size.height
            popAdVC?.view.frame = frame;
            
            popAdVC?.strGetOtp = strOTP
            popAdVC?.strGetQuery = strQueryID
                
            self.addChildViewController(popAdVC!)
            self.view.addSubview((popAdVC?.view)!)
            popAdVC?.didMove(toParentViewController: self)

        }
        else
        {
            print("Internet connection FAILED")
            
            alert()
            
        }
        
    }
    
    @IBAction func switchClk(_ sender: Any) {
        
        if addSwitch.isOn
        {
            let popAdVC = self.storyboard?.instantiateViewController(withIdentifier: "feature") as? FeaturedPopUp
            self.switchValue = true
            var frame: CGRect = popAdVC!.view.frame;
            frame.size.width = UIScreen.main.bounds.size.width
            frame.size.height = UIScreen.main.bounds.size.height
            popAdVC?.view.frame = frame;
            
            self.addChildViewController(popAdVC!)
            self.view.addSubview((popAdVC?.view)!)
            popAdVC?.didMove(toParentViewController: self)
        }
        else
        {
            self.switchValue = false
            self.addSwitch.setOn(false, animated: true)
        }
    }
    
}

extension RepairAndDescribeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectRepairType.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = selectRepairType[indexPath.row].repairType
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.cellForRow(at: indexPath)
        lblRepairType.text = selectRepairType[indexPath.row].repairType
        
        strRepairTypeID = selectRepairType[indexPath.row].repairID!
        fuelTableView.isHidden = true
    }
}

class responseArrayRepairService {
    var repairType : String?
    var repairID : String?
    
    init(repairType:String, repairID:String)
    {
        self.repairType = repairType
        self.repairID = repairID
    }
    
}

extension RepairAndDescribeVC: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RepairAndDescribeVC.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RepairAndDescribeVC.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        descTextView.delegate = self
        descTextView.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descTextView.text == "Please describe issue.."
        {
            descTextView.text = ""
        }
        else
        {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descTextView.text == ""
        {
            descTextView.text = "Please describe issue.."
        }
        else
        {
            
        }
    }


}

