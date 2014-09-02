//
//  File.swift
//  MMHS_Event_App
//
//  Created by Kevin McQuown on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import CoreLocation
import CloudKit

class User
{

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
        get {
            return record.objectForKey("details") as String!
        }
        set {
            record.setObject(newValue, forKey: "details")
        }
    }
    var date : NSDate!
    var location : CLLocationCoordinate2D!

    private var record : CKRecord!

    init(var theCKRecord : CKRecord)
    {
        record = theCKRecord
    }
}