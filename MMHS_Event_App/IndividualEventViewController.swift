//
//  IndividualEventViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class IndividualEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    let imagePicker = UIImagePickerController()
    var photosArray = NSMutableArray()

    var selectedPhoto = UIImage?()
    var selectedPhotoFilePath = NSURL?()

    var event = Event?()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.editing = true

//TODO: Photos
        println(event)

    }

    @IBAction func onCameraButtonTapped(sender: UIBarButtonItem)
    {
        actionSheet()
    }

    func actionSheet()
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Library")

        actionSheet.showInView(view)
    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else if buttonIndex == 2 {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        selectedPhoto = info[UIImagePickerControllerEditedImage] as UIImage!
        selectedPhotoFilePath = self.selectedPhoto?.urlWithImage()

        
    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StreamCell") as StreamTableViewCell

        return cell
    }
}
