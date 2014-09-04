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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.discoverUserInfo()

        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userRecordID, error) -> Void in

            self.publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (record, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                if error != nil {
                    // Error Code 11 - Unknown Item: did not find required record type
                    if (error.code == 11) {

                        // Since schema is missing, create the schema with demo records and return results

                    }
                    else {
                        // In your app, this error needs love and care.
                        println("An error occured in \(NSStringFromSelector(__FUNCTION__)): \(error)");
                        abort();
                    }
                    } else {
                        let theUser = Users(theCKRecord: record)
                        self.hometownLabel.text = theUser.hometown
                        self.bioLabel.text = theUser.bio
                    }
                })
            })
        }
    }

    func discoverUserInfo()
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
