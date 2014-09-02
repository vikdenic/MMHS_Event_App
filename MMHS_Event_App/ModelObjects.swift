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
    var name : String!
    var details : String!
    var date : NSDate!
    var location : CLLocationCoordinate2D!

    private var record : CKRecord!

    init(var record : CKRecord)
    {
        name = record.objectForKey("name") as String!

    }

}