//
//  CreateEventViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var selectPhotoButton: UIButton!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage?()
    var selectedImagePath = NSURL?()

    var currentUser = Users()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        selectPhotoButton.layer.cornerRadius = 5
    }

    @IBAction func onSelectPhotoTapped(sender: UIButton)
    {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in

            self.selectedImage = info[UIImagePickerControllerEditedImage] as UIImage!
            self.selectedImagePath = self.selectedImage?.urlWithImage()
        })
    }

    @IBAction func onDoneButtonTapped(sender: UIBarButtonItem)
    {
        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase

//        let currentUser = CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler
//        eventRecord.setObject("Test Event", forKey: "name")

        let newEvent = Event()

        newEvent.save { (succeeded, error) -> Void in
            if succeeded
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("savedEvent", object: self)
                })

            } else{
                println("Error saving data")
            }
        }
    }
//TODO:        eventRecord.location = location

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
