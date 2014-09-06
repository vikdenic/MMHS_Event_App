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

    var selectedProfileURL = NSURL()
    var selectedCoverURL = NSURL()

    var settingProfilePic = Bool()

    var testURL = NSURL()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        //MARK: CloudManager
        cloudManager.requestDiscoverabilityPermission { (discoverable) -> Void in
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
                self.selectedProfileURL = self.urlWithImage(self.selectedProfilePic)
            }
            else{
                let selectedCoverPhoto = info[UIImagePickerControllerEditedImage] as UIImage
                self.selectedProfileURL = self.urlWithImage(selectedCoverPhoto)
            }
        })
    }

    func urlWithImage(image : UIImage) -> NSURL
    {
        let data = UIImageJPEGRepresentation(image, 0.75)
        let cachesDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        let temporaryName = NSUUID.UUID().description.stringByAppendingPathExtension("jpeg")
        let localURL = cachesDirectory?.URLByAppendingPathComponent(temporaryName!)
        data.writeToURL(localURL!, atomically: true)

        return localURL!
    }

    //MARK: Bar Button Actions
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem)
    {
        let theUser = Users()

        theUser.retrieveCurrentUserDataFromCloud { (succeeded, error) -> Void in
            //
            if succeeded
            {
                //TODO: SET USER DATA HERE
                theUser.bio = self.bioTextField.text
                theUser.hometown = self.hometownTextField.text
                theUser.profilePhoto = CKAsset(fileURL: self.selectedProfileURL)

                theUser.save({succeeded, error in
                    if succeeded
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName("savedData", object: self)
                        })

                    } else{
                        println("Error saving data")
                    }
                })
            } else{
                println("Error retreiving user")
            }
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onDismissButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
