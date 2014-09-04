//
//  HomeViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        var currentiCloudAccountStatus : Void = CKContainer.defaultContainer().accountStatusWithCompletionHandler { (accessibility, error) -> Void in
            if accessibility == CKAccountStatus.Available
            {
                self.requestDiscoverability()
            }
            else{
                self.performSegueWithIdentifier("NoAccountSegue", sender: nil)
            }
        }
    }
//        if currentiCloudToken != nil
//        {
//            requestDiscoverability()
//        }
//        else{
//            performSegueWithIdentifier("NoUserSegue", sender: self)
//        }

    func requestDiscoverability()
    {
        let cloudManager = AAPLCloudManager()

        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                cloudManager.discoverUserInfo({ (user) -> Void in
                    self.discoveredUserInfo(user)
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
        //code to set data
    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as FeedTableViewCell
        return feedCell
    }

}
