//
//  EditProfileViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var selectedProfilePic = UIImage()
    var selectedCoverPhoto = UIImage()
    var settingProfilePic = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
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

    }

    @IBAction func onDismissButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
