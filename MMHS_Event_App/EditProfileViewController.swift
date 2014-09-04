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

    var selectedProfileURL = NSURL()
    var selectedCoverURL = NSURL()

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
        self.nameTextField.text = "\(user.firstName) \(user.lastName)"
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
                self.selectedProfileURL = info[UIImagePickerControllerReferenceURL] as NSURL
            }
            else{
                self.selectedCoverPhoto = info[UIImagePickerControllerEditedImage] as UIImage
                self.selectedCoverURL = info[UIImagePickerControllerReferenceURL] as NSURL
            }
        })
    }

    //MARK: Bar Button Actions
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem)
    {
        //access users record
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userRecordID, error) -> Void in

            self.publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (record, error) -> Void in

                //Create Users instance from record
                let theUser = Users(theCKRecord: record)
                theUser.hometown = self.hometownTextField.text
                theUser.bio = self.bioTextField.text

                theUser.save({succeeded, error in
                    if !succeeded
                    {

                    }
                })
           })
        }
    }

    @IBAction func onDismissButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
