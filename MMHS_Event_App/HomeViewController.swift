//
//  HomeViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventsArray = [Event]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var refreshButton: UIBarButtonItem!
    var selectedIndexPath = NSIndexPath()

    override func viewDidLoad()
    {
        retrieveEvents()
        //
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)

        checkForAccountAuthentification()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForAccountAuthentification", name: "opened", object: nil)
    }

    func retrieveEvents()
    {
        queryAllRecords("Event", { (records, result, error) -> Void in
            self.eventsArray = records
            self.tableView.reloadData()
        })
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

        let eventRecord = eventsArray[indexPath.row]
        //TODO:        profile pic

        let hostRef = eventRecord.host
        let hostID = hostRef.recordID

        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

        publicDatabase.fetchRecordWithID(hostID, completionHandler: { (record, error) -> Void in

            let user = Users(theCKRecord: record)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                feedCell.hostImageView.image = imageFromAsset(user.profilePic)
            })
        })

        feedCell.eventImageView.image = imageFromAsset(eventRecord.eventPhoto)

        feedCell.titleLabel.text = eventRecord.title
        let date = eventRecord.date
        feedCell.dateLabel.text = date.toNiceString()

        return feedCell
    }

    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toStream"
        {
        var individualVC = segue.destinationViewController as IndividualEventViewController

        individualVC.event = eventsArray[tableView.indexPathForSelectedRow()!.row]
            println("HOME: \(individualVC.event?.title)")
        }
    }
}
