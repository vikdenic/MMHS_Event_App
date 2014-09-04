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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        requestDiscoverability()
    }

    @IBAction func onButtonTapped(sender: UIButton)
    {
        requestDiscoverability()
    }


    func requestDiscoverability()
    {
        //MARK: CloudManager
        cloudManager .requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.cloudManager.discoverUserInfo({ (user) -> Void in
                            self.discoveredUserInfo(user)
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
    }

    func discoveredUserInfo(user : CKDiscoveredUserInfo!)
    {
        if user != nil
        {

        }
        else{
        }
    }
}
