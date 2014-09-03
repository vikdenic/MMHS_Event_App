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

class User
{
    var profilePhoto : CKAsset! {
        get {
            return record.objectForKey("profilePhoto") as CKAsset!
        }
        set {
            record.setObject(newValue, forKey: "profilePhoto")
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

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
}

class EventInvite
{
    var event : Event! {
        get {
            var ckRecordEvent = record.objectForKey("event") as CKRecord!
            return Event(theCKRecord: ckRecordEvent)
        }
        set {
            record.setValue(newValue, forKey: "event")
        }
    }

    var toUser : User! {
        get {
            var ckRecordUser = record.objectForKey("toUser") as CKRecord!
            return User(theCKRecord: ckRecordUser)
        }
        set {
            record.setValue(newValue, forKey: "toUser")
        }
    }

    var statusOfUser : String! {
        get {
            return record.objectForKey("statusOfUser") as String!
        }
        set {
            record.setObject(newValue, forKey: "statusOfUser")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
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

    var photographer : User! {
        get {
            var ckRecordUser = record.objectForKey("photographer") as CKRecord!
            return User(theCKRecord: ckRecordUser)
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

    var fromUser : User! {
        get {
            var ckRecordUser = record.objectForKey("fromUser") as CKRecord!
            return User(theCKRecord: ckRecordUser)
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
}

class Event
{
    var host : User! {
        get {
            var ckRecordUser = record.objectForKey("user") as CKRecord!
            return User(theCKRecord: ckRecordUser)
        }
        set {
            record.setValue(newValue, forKey: "host")
        }
    }

    var name : String! {
        get {
            return record.objectForKey("name") as String!
        }
        set {
            record.setObject(newValue, forKey: "name")
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
    //TODO:
    var usersAttending : [User]! {
        get {
            return record.objectForKey("usersAttending") as [User]!
        }
        set {
            record.setObject(newValue, forKey: "usersAttending")
        }
    }
    //TODO:
    var usersInvited : [User]! {
        get {
            return record.objectForKey("usersInvited") as [User]!
        }
        set {
            record.setObject(newValue, forKey: "usersInvited")
        }
    }

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
}