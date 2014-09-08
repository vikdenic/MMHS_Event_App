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

    @IBOutlet var changeProfPicButton: UIButton!
    @IBOutlet var changeCoverPhotoButton: UIButton!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var hometownTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!

    let imagePicker = UIImagePickerController()

    var selectedProfilePic = UIImage?()
    var selectedCoverPhoto = UIImage?()

    var selectedProfilePath = NSURL?()
    var selectedCoverPath = NSURL?()

    var settingProfilePic = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        changeCoverPhotoButton.layer.cornerRadius = 5
        changeProfPicButton.layer.cornerRadius = 5

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        //MARK: CloudManager
        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
            if discoverable
            {
                self.cloudManager.discoverUserInfo({ (discoveredUser) -> Void in
                    self.discoveredUserInfo(discoveredUser)
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

    override func viewWillAppear(animated: Bool)
    {
        let user = Users()
        user.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in

            self.bioTextField.text = user.bio
            self.hometownTextField.text = user.hometown
        }
    }

    func discoveredUserInfo(discoveredUser : CKDiscoveredUserInfo!)
    {
        self.nameTextField.text = "\(discoveredUser.firstName) \(discoveredUser.lastName)"

        let user = Users()
        user.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in
            //
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
                self.selectedProfilePic = info[UIImagePickerControllerEditedImage] as UIImage!
                self.selectedProfilePath = self.selectedProfilePic?.urlWithImage()
            }
            else{
                self.selectedCoverPhoto = info[UIImagePickerControllerEditedImage] as UIImage!
                self.selectedCoverPath = self.selectedCoverPhoto?.urlWithImage()
            }
        })
    }

    //MARK: Bar Button Actions
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem)
    {
        let theUser = Users()

        retrieveAndSetCurrentUserData(theUser, completed: { (succeeded, error) -> Void in

            theUser.save({succeeded, error in
                if succeeded
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName("updatedProfile", object: self)
                    })

                } else{
                    println("Error saving data")
                }
            })
        })

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func retrieveAndSetCurrentUserData(user : Users, completed : (succeeded : Bool, error : NSError!) -> Void)
    {
        user.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in

            if succeeded
            {
                //TODO: SET USER DATA HERE
                user.bio = self.bioTextField.text
                user.hometown = self.hometownTextField.text

                if self.selectedProfilePic != nil
                {
                    user.profilePic = CKAsset(fileURL: self.selectedProfilePath)
                }

                if self.selectedCoverPhoto != nil
                {
                    user.coverPhoto = CKAsset(fileURL: self.selectedCoverPath)
                }

                if error == nil
                {
                    completed(succeeded: true, error: error)
                }
                else {
                    completed(succeeded: false, error: error)
                }
            }
            else{
                println("Error retrieving user's record")
            }
        }
    }

    @IBAction func onDismissButtonTapped(sender : UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
