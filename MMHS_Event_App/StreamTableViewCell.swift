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
    @IBOutlet var photographerLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        likesLabel.layer.cornerRadius = 5
    }
}
