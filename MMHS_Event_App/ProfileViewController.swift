//
//  ProfileViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var hometownLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!

    @IBOutlet var tableView: UITableView!

    var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let cloudManager = AAPLCloudManager()

    var eventsArray = [Event]()

    override func viewWillAppear(animated: Bool)
    {
        self.accessUserInfo()
        retrieveDataAndSetViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "retrieveDataAndSetViews", name: "updatedProfile", object: nil)
    }

    func retrieveDataAndSetViews()
    {
        var theUser = Users()
        theUser.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in
            self.hometownLabel.text = theUser.hometown
            self.bioLabel.text = theUser.bio

            if theUser.profilePic != nil
            {
                self.profileImageView.image = imageFromAsset(theUser.profilePic as CKAsset)
            }
            if theUser.coverPhoto != nil
            {
                self.coverImageView.image = imageFromAsset(theUser.coverPhoto as CKAsset)
            }
        }
    }

    func accessUserInfo()
    {
        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                self.cloudManager.discoverUserInfo({ (user) -> Void in
                    self.discoveredUserInfo(user)
                    //block call back
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
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        self.title = "\(user.firstName)"
    }

    func retrieveEvents()
    {
        queryAllRecords("Event", { (records, result, error) -> Void in
            self.eventsArray = records
            self.tableView.reloadData()
        })
    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as ProfileTableViewCell
        let eventRecord = eventsArray[indexPath.row]
        //TODO:        profile pic

        let hostRef = eventRecord.host

        recordFromReference(hostRef, { (record, result, error) -> Void in
            let user = Users(theCKRecord: record!)
            cell.userImageView.image = imageFromAsset(user.profilePic)
        })

        cell.eventImageView.image = imageFromAsset(eventRecord.eventPhoto)

        cell.titleLabel.text = eventRecord.title
        let date = eventRecord.date
        cell.dateLabel.text = date.toNiceString()
        return cell
    }

    //MARK: ScrollView
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let pageNumber = roundf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))
        self.pageControl.currentPage = Int(pageNumber)
    }

    override func viewDidLayoutSubviews()
    {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, 320)
    }
}
