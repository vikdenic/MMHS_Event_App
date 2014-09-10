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
    }

    override func viewWillAppear(animated: Bool)
    {
        queryAllEvents({ (records, result, error) -> Void in
            for event in records
            {
                self.addpins(ofRecord: event, image: imageFromAsset(event.eventPhoto))
            }
        })
    }

    //MARK: CLLocation
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
    }

    //MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {

        let annot = annotation as EventAnnotation
        let annotview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)

        var scaleSize = CGSizeMake(65, 65)
        UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0)
        annot.pic.drawInRect(CGRectMake(0, 0, scaleSize.width, scaleSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotview.image = resizedImage
        annotview.layer.cornerRadius = annotview.image.size.width / 2
        annotview.clipsToBounds = true
        return annotview
    }

    func addpins(ofRecord record: Event, image : UIImage)
    {
        var pin = EventAnnotation()
        pin.coordinate = record.location.coordinate
        pin.pic = image
        mapView.addAnnotation(pin)
    }
}
