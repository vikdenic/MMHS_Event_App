//
//  File.swift
//  MMHS_Event_App
//
//  Created by Kevin McQuown on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit

class Users
{
    var profilePic : CKAsset! {
        get {
            return record.objectForKey("profilePic") as CKAsset!
        }
        set {
            record.setObject(newValue, forKey: "profilePic")
        }
    }

    var coverPhoto : CKAsset! {
        get {
            return record.objectForKey("coverPhoto") as CKAsset!
        }
        set {
            record.setObject(newValue, forKey: "coverPhoto")
        }
    }

    var bio : String! {
        get {
            return record.objectForKey("bio") as String!
        }
        set {
            record.setObject(newValue, forKey: "bio")
        }
    }

    var hometown : String! {
        get {
            return record.objectForKey("hometown") as String!
        }
        set {
            record.setObject(newValue, forKey: "hometown")
        }
    }

    private var record : CKRecord!


    func retrieveCurrentUserDataFromCloud(complete:(succeeded : Bool, error : NSError!) -> Void)
    {
        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userRecordID, error) -> Void in

            publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (theRecord, error) -> Void in

                if error == nil
                {
                    self.record = theRecord
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        complete(succeeded: true, error: error)
                    })
                }
                else {
                    complete(succeeded: false, error: error)
                }
            })
        }
    }

    func save(complete:(succeeded : Bool, error : NSError!) -> Void)
    {
        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(record) { (resultRecord, error) -> Void in
            if error == nil
            {
                complete(succeeded: true, error: error)
            }
            else {
                complete(succeeded: false, error: error)
            }
        }
    }

    init()
    {
        record = nil
    }

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
}

class Event
{

    var host : CKReference! {
        get {
            return record.objectForKey("host") as CKReference!
        }
        set {
            record.setValue(newValue, forKey: "host")
        }
    }

    var title : String! {
        get {
            return record.objectForKey("title") as String!
        }
        set {
            record.setObject(newValue, forKey: "title")
        }
    }

    var details : String! {
        get
        {
            return record.objectForKey("details") as String!
        }
        set {
            record.setObject(newValue, forKey: "details")
        }
    }
    var date : NSDate! {
        get {
            return record.objectForKey("date") as NSDate!
        }
        set {
            record.setObject(newValue, forKey: "date")
        }
    }

    var location : CLLocation! {
        get {
            return record.objectForKey("location") as CLLocation!
        }
        set {
            record.setObject(newValue, forKey: "location")
        }
    }

    var eventPhoto : CKAsset! {
        get {
            return record.objectForKey("eventPhoto") as CKAsset!
        }
        set {
            record.setObject(newValue, forKey: "eventPhoto")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }

    func saveInBackground(complete:(succees : Bool) -> Void)
    {
        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
            complete(succees: true)
        })
    }

    init()
    {
        record = nil
    }

    func eventWithCurrentHost()
    {
        var currentUser = Users()
        currentUser.retrieveCurrentUserDataFromCloud { (succeeded, error) -> Void in
        }
        host = CKReference(record: currentUser.record, action: CKReferenceAction.None)
    }
}

//Returns UIImage from filePath of a CKAsset
func imageFromAsset(asset : CKAsset) -> UIImage
{
    var photoAsset = asset
    return UIImage(contentsOfFile: photoAsset.fileURL.path!)
}

class Photo
{
    var image : CKAsset! {
        get {
            return record.objectForKey("image") as CKAsset!
        }
        set {
            record.setObject(newValue, forKey: "image")
        }
    }

    var event : Event! {
        get {
            var ckRecordEvent = record.objectForKey("event") as CKRecord!
            return Event(theCKRecord: ckRecordEvent)
        }
        set {
            record.setValue(newValue, forKey: "event")
        }
    }

    var photographer : Users! {
        get {
            var ckRecordUser = record.objectForKey("photographer") as CKRecord!
            return Users(theCKRecord: ckRecordUser)
        }
        set {
            record.setValue(newValue, forKey: "photographer")
        }
    }

    var likeActivity : LikeActivity! {
        get {
            var ckRecordLikeActivity = record.objectForKey("likeActivity") as CKRecord!
            return LikeActivity(theCKRecord: ckRecordLikeActivity)
        }
        set {
            record.setValue(newValue, forKey: "likeActivity")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
}

class LikeActivity
{
    var photo : Photo!  {
        get {
            var ckRecordPhoto = record.objectForKey("photo") as CKRecord!
            return Photo(theCKRecord: ckRecordPhoto)
        }
        set {
            record.setValue(newValue, forKey: "photo")
        }
    }

    var fromUser : Users! {
        get {
            var ckRecordUser = record.objectForKey("fromUser") as CKRecord!
            return Users(theCKRecord: ckRecordUser)
        }
        set {
            record.setValue(newValue, forKey: "fromUser")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }

    init()
    {
        record = nil
    }
}

extension UIImage{
    func urlWithImage() -> NSURL!
    {
        let data = UIImageJPEGRepresentation(self, 0.75)
        let cachesDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        let temporaryName = NSUUID.UUID().description.stringByAppendingPathExtension("jpeg")
        let localURL = cachesDirectory?.URLByAppendingPathComponent(temporaryName!)
        data.writeToURL(localURL!, atomically: true)

        return localURL!
    }
}