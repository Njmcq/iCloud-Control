//
//  ViewController.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 10-02-23.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2023 Nick McQuade. All rights reserved.

import Foundation
import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var openButton: NSButton!
    @IBOutlet weak var explainLabel: NSTextField!
    @IBOutlet weak var demoImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = ProcessInfo.processInfo.operatingSystemVersion
        
        if version.majorVersion >= 13 {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Settings. You can then close this app and get going!"
            openButton.title = "Open System Settings"
            demoImage.image = NSImage(named: "SysSettingsPane")
        } else {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Preferences. You can then close this app and get going!"
            openButton.title = "Open System Preferences"
            demoImage.image = NSImage(named: "SysPrefsPane")
        }
    }
    
    @IBAction func openSystemPreferences(_ sender: AnyObject) {
        NSWorkspace.shared.open(URL(fileURLWithPath:("/System/Library/PreferencePanes/Extensions.prefPane")
                                   ))
    }
}
