//
//  ProfilePicImageView.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/5/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class ProfilePicImageView: UIImageView {

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
