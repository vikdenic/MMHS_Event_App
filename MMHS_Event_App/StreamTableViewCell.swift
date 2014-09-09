//
//  StreamTableViewCell.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/7/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class StreamTableViewCell: UITableViewCell {

    @IBOutlet var streamImageView: UIImageView!
    @IBOutlet var photographerImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!

    override func awakeFromNib(){
        super.awakeFromNib()
        photographerImageView.layer.cornerRadius = photographerImageView.frame.size.width / 2
        photographerImageView.clipsToBounds = true
    }
}
