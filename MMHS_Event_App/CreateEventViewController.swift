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

    //MARK: View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        selectPhotoButton.layer.cornerRadius = 5
    }

    //MARK: UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in

            self.selectedImage = info[UIImagePickerControllerEditedImage] as UIImage!
            self.selectedImagePath = self.selectedImage?.urlWithImage()
        })
    }

    //MARK: Geocoding
    func geocodeLocationWithBlock(located : (succeeded : Bool, error : NSError!) -> Void)
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
               self.showErrorAlert("Oops!", message: "Please enter a valid location.")
            }
        })
    }

    //MARK: Helpers
    func setDataAndSave()
    {
        let newEvent = Event()
        newEvent.title = titleTextField.text
        newEvent.details = detailsTextField.text
        newEvent.location = location
        newEvent.date = datePicker.date

        if selectedImage != nil
        {
        newEvent.eventPhoto = CKAsset(fileURL: selectedImage?.urlWithImage())
        }
        else{
            showErrorAlert("Oops!", message: "Don't forget to select a photo.")
        }

        var currentUser = Users()
        currentUser.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in
            newEvent.host = CKReference(record: currentUser.record, action: CKReferenceAction.DeleteSelf)

            newEvent.save { (succeeded, error) -> Void in
                if succeeded
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName("savedEvent", object: self)
                    })

                } else{
                    self.showErrorAlert("Oops!", message: "Something didn't work. Try again later.")
                }
            }
        }
    }

    //MARK: Actions
    @IBAction func onSelectPhotoTapped(sender: UIButton)
    {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onDoneButtonTapped(sender: UIBarButtonItem)
    {
        geocodeLocationWithBlock{ (succeeded, error) -> Void in
            self.setDataAndSave()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: Error Handling
    func showErrorAlert(withTitle : String, message : String)
    {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (var act) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
