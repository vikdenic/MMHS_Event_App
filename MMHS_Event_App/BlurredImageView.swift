//
//  BlurredImageView.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class BlurredImageView: UIImageView {

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        var blur : UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = frame
        addSubview(effectView)
    }
}
