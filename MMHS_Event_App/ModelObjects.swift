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

}

class Photo
{

}

class LikeActivity
{

}

class Event
{
    var host : User!

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

    var usersAttending : [User]! {
        get {
            return record.objectForKey("usersAttending") as [User]!
        }
        set {
            record.setObject(newValue, forKey: "usersAttending")
        }
    }

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