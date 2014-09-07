//
//  CreateEventViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var selectPhotoButton: UIButton!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage?()
    var selectedImagePath = NSURL?()

    var location = CLLocation?()

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


    func geocodeLocationAndSetAllData(located : (succeeded : Bool, error : NSError!) -> Void)
    {
        var geocode = CLGeocoder()
        geocode.geocodeAddressString(locationTextField.text, completionHandler: { (placemarks, error) -> Void in
            if error == nil
            {
                let locations : [CLPlacemark]  = placemarks as [CLPlacemark]
                self.location = locations[0].location
                located(succeeded: true, error: error)
            }
            else{
                println("error")
            }
        })
    }

    func setDataAndSave()
    {
        var publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        //        setLocation()
        //        let currentUser = CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler
        //        eventRecord.setObject("Test Event", forKey: "name")

        let newEvent = Event()
        newEvent.title = titleTextField.text
        newEvent.details = detailsTextField.text
        newEvent.location = location

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

    @IBAction func onDoneButtonTapped(sender: UIBarButtonItem)
    {
        geocodeLocationAndSetAllData { (succeeded, error) -> Void in
            self.setDataAndSave()
        }
    }

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
