//
//  InvitesViewController.swift
//  MMHS_Event_App
//
//  Created by Vik Denic on 9/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

import UIKit

class InvitesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onDismissButtonTapped(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
