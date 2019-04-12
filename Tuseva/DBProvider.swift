//
//  DBProvider.swift
//  Tuseva
//
//  Created by oms183 on 10/3/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider
{
    private static let _instance = DBProvider()
    private init() {}
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
//    var dbHandler: FIRDatabaseHandle!
    
    var userRef: FIRDatabaseReference {
        return dbRef.child(Constants.USER)
    }
    
    var tusevaUserRef: FIRDatabaseReference {
        return userRef.child(Constants.TUSEVA_USER)
    }
    
//    var tusevaUserRef: FIRDatabaseReference {
//        return userRef.child(Constants.TUSEVA_USER)
//    }
    
    var messagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MESSAGES)
    }
    
    var qIDspIDuIDRef: FIRDatabaseReference {
        return messagesRef.child(Constants.MESSAGES_QID)
    }
    
    var chatRef: FIRDatabaseReference {
        return qIDspIDuIDRef.child(Constants.CHAT)
    }
    
    var timestampRef: FIRDatabaseReference {
        return qIDspIDuIDRef.child(Constants.TIME_STAMP)
    }
    
    
    var IdRef : FIRDatabaseReference {
        return chatRef.childByAutoId()
    }
    
    var mediaMessagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://tusevaserviceprovider.appspot.com")
    }
    
    var imageStorageRef: FIRStorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    func saveUser(withID: String, device_token:String, email:String, user_id:String, status:Bool, typing:Bool) {
        
        let data:Dictionary<String,Any> = [Constants.DEVICE_TOKEN:device_token,Constants.EMAIL:email, Constants.USERID:user_id,Constants.STATUS:status,Constants.TYPING:typing]
        
        tusevaUserRef.child(withID).setValue(data)
    }

    func saveMessage(withID: String, address:String, date:String, description:String, id:String, image:String, mobile_no:String, msg:String,profile_image:String, query_id:String, query_image:String, receiver_id:String, send_image_gallery_camera:String, sender_id:String, service_provider_name:String, time: Int, upload_image_video:String) {
        
        
        let data:Dictionary<String,Any> = [Constants.ADDRESS:address, Constants.DATE:date, Constants.DESCRIPTION:description, Constants.USERID:id, Constants.IMAGE:image, Constants.MOBILE:mobile_no, Constants.MSG:msg,Constants.PROFILE_IMAGE:profile_image, Constants.QUERY_ID:query_id, Constants.QUERY_IMAGE:query_image, Constants.RECEIVER_ID:receiver_id, Constants.SEND_IMAGE:send_image_gallery_camera, Constants.SENDER_ID:sender_id, Constants.SERVICE_PROVIDER_NAME:service_provider_name, Constants.TIME:time,Constants.UPLOAD_VIDEO:upload_image_video]
        
        chatRef.child(withID).setValue(data)
        //        timestampRef.child("\(Int(Date().timeIntervalSince1970))")
    }
    
    
    
    
//    func DownloadAllMessages(forQueryID:String, service_provider_ID:String, sender_ID:String) {
//        
////        FIRDataSnapshot.exists(DBProvider.Instance.qIDspIDuIDRef)
//        
//        
//        dbHandler = qIDspIDuIDRef.child(Constants.CHAT).observe(.childAdded, with: { (snapshot) in
//            if let item = snapshot.value as? String {
//                
//            }
//        })
//        
////        dbHandler = qIDspIDuIDRef.child(Constants.CHAT).observewithEventType(.Value, withBlock: {(snap) in
////        })
////        
//    }
    
    
    
}
