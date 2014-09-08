//
//  ExploreViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var eventsArray = NSMutableArray()

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        queryAllRecords("Event", eventsArray) { (result, error) -> Void in
            for event in self.eventsArray
            {
                self.addpin(event as CKRecord)
            }
        }
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
        currentLocation = locationManager.location

        mapView.region.span = MKCoordinateSpanMake(1.0, 1.0)
        mapView.setCenterCoordinate(currentLocation.coordinate, animated: true)
    }

    func addpin(record : CKRecord)
    {
        var pin = MKPointAnnotation()
        var location = record.valueForKey("location") as CLLocation
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
    }
}
