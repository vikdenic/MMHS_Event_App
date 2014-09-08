//
//  ExploreViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var eventsArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        queryAllRecords("Event", eventsArray) { (result, error) -> Void in
            for event in self.eventsArray
            {
                self.addpin(event as CKRecord)
            }
        }
    }

    func addpin(record : CKRecord)
    {
        var pin = MKPointAnnotation()
        var location = record.valueForKey("location") as CLLocation
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
    }
}
