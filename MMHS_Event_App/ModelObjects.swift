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

    func setRecordToCurrentUsersRecordWithBlock(complete:(succeeded : Bool, error : NSError!) -> Void)
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

    var record : CKRecord!

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

    var photos : CKReference! {
        get {
            return record.objectForKey("photos") as CKReference!
        }
        set {
            record.setObject(newValue, forKey: "photos")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }

    func initNewEvent(var withName: String)
    {

    }

    func recordValue() -> CKRecord!
    {
        return record
    }

    init()
    {
        record = CKRecord(recordType: "Event")
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

    var event : CKReference! {
        get {
            return record.objectForKey("event") as CKReference!
        }
        set {
            record.setValue(newValue, forKey: "event")
        }
    }

    var photographer : CKReference! {
        get {
            return record.objectForKey("photographer") as CKReference!
        }
        set {
            record.setValue(newValue, forKey: "photographer")
        }
    }

    var likes : Int! {
        get {
            return record.objectForKey("likes") as Int!
        }
        set {
            record.setValue(newValue, forKey: "likes")
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

    func recordValue() -> CKRecord!
    {
        return record
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }

    init()
    {
        record = CKRecord(recordType: "Photo")
    }
}

func queryAllRecords(recordType: String!, completed: (records:[Event]!, result: Bool, error: NSError!) -> Void){
    var database: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

    var results = [Event]()

    let truePredicate = NSPredicate(value: true)
    let query = CKQuery(recordType: recordType, predicate: truePredicate)
    let queryOperation = CKQueryOperation(query: query)

    queryOperation.recordFetchedBlock = { (record : CKRecord!) in
        results.append(Event(theCKRecord: record))
    }

    queryOperation.queryCompletionBlock = { (cursor : CKQueryCursor!, error : NSError!) in
        if error != nil{
            completed(records: nil, result: false, error: error)

        } else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

            completed(records: results, result: true, error: error)
//            println(toArray)
            })
        }
    }

    database.addOperation(queryOperation)
}

func getPhotographerOfPhoto(photo: Photo,completed: (user: Users?, result: Bool, error: NSError!) -> Void)
{

}

//Convers CKReference to CKRecord to be handled on main thread
func recordFromReference(reference: CKReference,completed: (record:CKRecord?, result: Bool, error: NSError!) -> Void)
{
    let recordID = reference.recordID

    var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

    publicDatabase.fetchRecordWithID(recordID, completionHandler: { (record, error) -> Void in

        if error != nil{
            completed(record: nil, result: false, error: error)
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completed(record: record!, result: true, error: error)
            })
        }
    })
}

func getPhotosForEvent(event : Event, completed: (photos:[Photo]!, result:Bool, error: NSError!) -> Void)
{
    
}

func queryPhotoRecords(recordType: String!, withPredicate : NSPredicate!, completed: (records:[Photo]!, result: Bool, error: NSError!) -> Void){
    var database: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

    var results = [Photo]()

//    let truePredicate = NSPredicate(value: true)
    let query = CKQuery(recordType: recordType, predicate: withPredicate)
    let queryOperation = CKQueryOperation(query: query)

    queryOperation.recordFetchedBlock = { (record : CKRecord!) in
        results.append(Photo(theCKRecord: record))
    }

    queryOperation.queryCompletionBlock = { (cursor : CKQueryCursor!, error : NSError!) in
        if error != nil{
            completed(records: nil, result: false, error: error)

        } else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completed(records: results, result: true, error: error)
            })
        }
    }
    
    database.addOperation(queryOperation)
}

extension NSDate{
    func toNiceString() -> String
    {
        //convert to regular looking time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "cccc, MMM d, hh:mm aa"
        return dateFormatter.stringFromDate(self)
    }
}

extension UIImage{
    func urlWithImage() -> NSURL!
    {
        let data = UIImageJPEGRepresentation(self, 0.75)
        let cachesDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        let temporaryName = NSUUID().description.stringByAppendingPathExtension("jpeg")
        let localURL = cachesDirectory?.URLByAppendingPathComponent(temporaryName!)
        data.writeToURL(localURL!, atomically: true)

        return localURL!
    }
}