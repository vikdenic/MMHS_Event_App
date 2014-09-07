//
//  CreateEventViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var selectPhotoButton: UIButton!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage?()
    var selectedImagePath = NSURL?()

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


    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
