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

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func geocodeLocation(location : String)
    {
        var geocode = CLGeocoder()
        geocode.geocodeAddressString(location, completionHandler: { (objects, error) -> Void in
            if error != nil
            {
                println("error")
            }
            else{

            }
        })
    }
}
