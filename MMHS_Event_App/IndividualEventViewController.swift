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

    //MARK: View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let photosRef = event?.photos

        getPhotosForEvent(event!, { (photos, result, error) -> Void in
            for photo in photos
            {
                self.photosArray.append(photo)
                self.tableView.reloadData()
            }
        })
    }

    //Action Sheet
    @IBAction func onCameraButtonTapped(sender: UIBarButtonItem) {
        actionSheet()
    }

    func actionSheet() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Library")

        actionSheet.showInView(view)
    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
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

    //MARK: UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        selectedPhoto = info[UIImagePickerControllerEditedImage] as UIImage!

        let photo = Photo()

        var currentUser = Users()
        currentUser.setRecordToCurrentUsersRecordWithBlock { (succeeded, error) -> Void in

            photo.photographer = CKReference(record: currentUser.record, action: CKReferenceAction.None)
            photo.event = CKReference(record: self.event?.recordValue(), action: CKReferenceAction.DeleteSelf)
            photo.image = CKAsset(fileURL: self.selectedPhoto?.urlWithImage())
            photo.dateTaken = NSDate()
            photo.likesCount = 0

            photo.save({ (succeeded, error) -> Void in
                self.photosArray.append(photo)
                self.tableView.reloadData()
            })

        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: Other Actions
    @IBAction func onLikeButtonTapped(sender: UIButton){

        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as StreamTableViewCell
        let photo = photosArray[sender.tag]

        let selectedImage = UIImage(named: "likeSelected")
        let unselectedImage = UIImage(named: "likeUnselected")

        if sender.imageView?.image == unselectedImage{
            sender.setImage(UIImage(named: "likeSelected"), forState: UIControlState.Normal)
            photo.likesCount = photo.likesCount + 1
            photo.save({ (succeeded, error) -> Void in
                self.tableView.reloadData()
            })
        } else{
            sender.setImage(UIImage(named: "likeUnselected"), forState: UIControlState.Normal)
            photo.likesCount = photo.likesCount - 1
            photo.save({ (succeeded, error) -> Void in
                self.tableView.reloadData()
            })
        }
    }

    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StreamCell") as StreamTableViewCell

        let photo = photosArray[indexPath.row] as Photo
        cell.streamImageView.image = imageFromAsset(photo.image)

        getPhotographersProfilePic(fromPhoto: photo) { (image, result, error) -> Void in
            cell.photographerImageView.image = image
        }

        cell.dateLabel.text = photo.dateTaken.toOtherString()
        cell.likesLabel.text = "\(photo.likesCount)"
        cell.likeButton.tag = indexPath.row
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 390
    }
}
