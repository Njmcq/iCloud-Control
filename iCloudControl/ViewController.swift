//
//  ViewController.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022 Nick McQuade. All rights reserved.

import Cocoa

class ViewController: NSViewController {

    @IBAction func openSystemPreferences(_ sender: AnyObject) {
        NSWorkspace.shared.openFile("/System/Library/PreferencePanes/Extensions.prefPane")
    }

}

