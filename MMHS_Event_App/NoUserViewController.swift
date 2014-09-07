//
//  NoUserViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class NoUserViewController: UIViewController {

    let cloudManager = AAPLCloudManager()
    @IBOutlet var label: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        requestDiscoverability()
        animateLabel()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestDiscoverability", name: "opened", object: nil)
    }

    func requestDiscoverability()
    {
        //MARK: CloudManager
        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.cloudManager.discoverUserInfo({ (user) -> Void in
                    })
                })
            } else{
                let alert = UIAlertController(title: "CloudKit", message: "Getting your name using Discoverability requires permission", preferredStyle: UIAlertControllerStyle.Alert)

                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (var act) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        println("oh whatup")
    }

    func animateLabel()
    {
        label.alpha = 0
        UIView.animateWithDuration(2) { () -> Void in
            self.label.alpha = 1;
        }
    }
}
