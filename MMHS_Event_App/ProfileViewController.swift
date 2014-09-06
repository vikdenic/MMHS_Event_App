//
//  ProfileViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var hometownLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!

    var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let cloudManager = AAPLCloudManager()

    override func viewWillAppear(animated: Bool)
    {
        self.accessUserInfo()
        self.retrieveDataFromCloud()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "retrieveDataFromCloud", name: "savedData", object: nil)
    }
    
    func retrieveDataFromCloud()
    {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userRecordID, error) -> Void in

            self.publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (record, error) -> Void in

                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    if error != nil {

                    } else {
                        let theUser = Users(theCKRecord: record)
                        self.hometownLabel.text = theUser.hometown
                        self.bioLabel.text = theUser.bio
                        var photoAsset = theUser.profilePhoto as CKAsset
                        self.profileImageView.image = UIImage(contentsOfFile: photoAsset.fileURL.path!)
                    }
                })
            })
        }
    }

    func accessUserInfo()
    {
        cloudManager .requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                self.cloudManager.discoverUserInfo({ (user) -> Void in
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
        nameLabel.text = "\(user.firstName) \(user.lastName)"
    }

    override func viewDidLayoutSubviews()
    {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, 320)
    }
}
