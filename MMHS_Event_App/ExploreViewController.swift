//
//  ExploreViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExploreViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var eventsArray = [Event]()

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        queryAllRecords("Event", { (records, result, error) -> Void in
            for event in records
            {
                self.addpin(event)
            }
        })
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println(error)
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        for location in locations as [CLLocation]
        {
            if location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000
            {
                locationManager.stopUpdatingLocation()
                mapView.setRegion(MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
                println(location)
            }
        }
//        mapView.showsUserLocation = true
//        currentLocation = locationManager.location


//        mapView.region.span = MKCoordinateSpanMake(0.1, 0.1)
//        mapView.setCenterCoordinate(currentLocation.coordinate, animated: true)
    }

    func addpin(record : Event)
    {
        var pin = MKPointAnnotation()
        var location = record.location
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
    }
}
