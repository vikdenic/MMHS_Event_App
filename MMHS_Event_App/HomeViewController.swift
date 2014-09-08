//
//  HomeViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventsArray = NSMutableArray()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var refreshButton: UIBarButtonItem!

    override func viewDidLoad()
    {
        retrieveEvents()

    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)

        checkForAccountAuthentification()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForAccountAuthentification", name: "opened", object: nil)
    }

    func retrieveEvents()
    {
            queryAllRecords("Event", eventsArray) { (result, error) -> Void in

                self.tableView.reloadData()
            }
    }

    func checkForAccountAuthentification()
    {
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

    func requestDiscoverability()
    {
        let cloudManager = AAPLCloudManager()

        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                cloudManager.discoverUserInfo({ (user) -> Void in

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

    @IBAction func onRefreshButtonTapped(sender: UIBarButtonItem)
    {
        if eventsArray.count > 0
        {
            retrieveEvents()
        }
    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eventsArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as FeedTableViewCell


        let eventRecord = eventsArray[indexPath.row] as CKRecord
        //TODO:        profile pic

        let hostRef = eventRecord.valueForKey("host") as CKReference
        let hostID = hostRef.recordID
        let host = CKRecord(recordType: "Users", recordID: hostID)
        if host.valueForKey("profilePic") != nil
        {
            let hostPicAsset = host.valueForKey("profilePic") as CKAsset
            let hostPic = imageFromAsset(hostPicAsset) as UIImage
            feedCell.hostImageView.image = hostPic
        }

        feedCell.titleLabel.text = eventRecord.valueForKey("title") as String!
        
        let date = eventRecord.valueForKey("date") as NSDate
        feedCell.dateLabel.text = date.toNiceString()

        if eventRecord.valueForKey("eventPhoto") != nil
        {
        feedCell.eventImageView.image = imageFromAsset(eventRecord.valueForKey("eventPhoto") as CKAsset)
        }

        return feedCell
    }
}
