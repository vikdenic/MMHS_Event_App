//
//  EditProfileViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import CloudKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let cloudManager = AAPLCloudManager()

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var hometownTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!

    let imagePicker = UIImagePickerController()
    var selectedProfilePic = UIImage()
    var selectedCoverPhoto = UIImage()
    var settingProfilePic = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        //MARK: CloudManager
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
        if user != nil
        {
            self.nameTextField.text = "\(user.firstName) \(user.lastName)"
        }
        else{
            self.nameTextField.text = "Not signed into iCloud"
        }
    }

    //MARK: image picker
    @IBAction func onChangePhotoTapped(sender: UIButton)
    {
        if sender.tag == 0
        {
            settingProfilePic = true
        }
        else{
            settingProfilePic = false
        }

        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in

            if self.settingProfilePic == true
            {
                self.selectedProfilePic = info[UIImagePickerControllerEditedImage] as UIImage
            }
            else{
                self.selectedCoverPhoto = info[UIImagePickerControllerEditedImage] as UIImage
            }
        })
    }

    //MARK: Bar Button Actions
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem)
    {
//        let currentUser = CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler
//        var eventRecord = CKRecord(recordType: "Event")
//        eventRecord.setObject("Test Event", forKey: "name")
//        publicDatabase.saveRecord(eventRecord, completionHandler: nil)
    }

    @IBAction func onDismissButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
//
//        var predicate = NSPredicate(value: true)
//        var myQuery = CKQuery(recordType: "Event", predicate: predicate)
//        publicDatabase.performQuery(myQuery, inZoneWithID: nil, completionHandler: {records, error in
//            if let err = error {
//                var alert = UIAlertController(title: "iCloud Connection Error", message: err.localizedDescription, preferredStyle: .Alert)
//                var alertOK = UIAlertAction(title: "Rats!", style: .Default, handler: nil)
//                alert.addAction(alertOK)
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
//            else {
//                var myData = records as [CKRecord]
//                println(myData)
//            }
//        })
    }
}
