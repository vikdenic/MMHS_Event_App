//
//  HomeViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventsArray = [CKRecord]()
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        queryForEvents()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)

        checkForAccountAuthentification()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForAccountAuthentification", name: "opened", object: nil)
    }

    func queryForEvents()
    {
        self.eventsArray.removeAll(keepCapacity: false)

        var database: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

        let truePredicate = NSPredicate(value: true)
        let eventQuery = CKQuery(recordType: "Event", predicate: truePredicate)

        let queryOperation = CKQueryOperation(query: eventQuery)

        queryOperation.recordFetchedBlock = { (record : CKRecord!) in
            self.eventsArray.append(record)
            println("recordFetchedBlock: \(self.eventsArray)")
        }

        queryOperation.queryCompletionBlock = { (cursor : CKQueryCursor!, error : NSError!) in
            self.tableView.reloadData()
            println("complete")
        }

        database.addOperation(queryOperation)
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

//                    self.title = "Hi, \(user.firstName)!"

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
        queryForEvents()
    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eventsArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as FeedTableViewCell
//TODO:        let imageAsset = eventsArray[indexPath.row].valueForKey("eventPhoto") as CKAsset
        let eventRecord = eventsArray[indexPath.row] as CKRecord
        feedCell.titleLabel.text = eventRecord.valueForKey("title") as String!

        if eventRecord.valueForKey("eventPhoto") != nil
        {
        feedCell.eventImageView.image = imageFromAsset(eventRecord.valueForKey("eventPhoto") as CKAsset)
        }

        return feedCell
    }
}
