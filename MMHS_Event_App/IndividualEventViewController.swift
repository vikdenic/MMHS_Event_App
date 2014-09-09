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
    var photosArray = [Photo]()

    var selectedPhoto = UIImage?()
    var selectedPhotoFilePath = NSURL?()

    var event = Event?()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let photosRef = event?.photos

//        let predicate = NSPredicate(format: "event == %@", CKReference(record: event?.recordValue(), action: CKReferenceAction.None))
//        let predicate = NSPredicate(value: true)

        let predicate = NSPredicate(format: "event == %@", event!.recordValue())

        queryPhotoRecords("Photo", predicate) { (records, result, error) -> Void in
            for photo in records
            {
                self.photosArray.append(photo)
                self.tableView.reloadData()
            }
        }
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

        let photo = Photo()

        var currentUser = Users()
        currentUser.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in

            photo.photographer = CKReference(record: currentUser.record, action: CKReferenceAction.None)
            photo.event = CKReference(record: self.event?.recordValue(), action: CKReferenceAction.None)
            photo.image = CKAsset(fileURL: self.selectedPhoto?.urlWithImage())
            photo.likes = 0

            photo.save({ (succeeded, error) -> Void in
                self.photosArray.append(photo)
                self.tableView.reloadData()
            })

        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func onLikeButtonTapped()
    {

    }

    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return photosArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StreamCell") as StreamTableViewCell
        let photo = photosArray[indexPath.row] as Photo
        cell.streamImageView.image = imageFromAsset(photo.image)

        let photographer = photo.photographer
        recordFromReference(photographer, { (record, result, error) -> Void in
            let user = Users(theCKRecord: record!)
            cell.photographerImageView.image = imageFromAsset(user.profilePic)
        })

        cell.likeButton.tag = indexPath.row
        cell.likeButton .addTarget(self, action: "onLikeButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 390
    }


}
