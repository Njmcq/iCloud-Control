//
//  ViewController.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2023 Nick McQuade. All rights reserved.

import Foundation
import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var openButton: NSButton!
    @IBOutlet weak var explainLabel: NSTextField!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Set the window behavior to zoom instead of maximize
        view.window?.collectionBehavior = .fullScreenNone
        
        view.window?.delegate = self
        
        // MARK: - Change UI based on OS version
        let version = ProcessInfo.processInfo.operatingSystemVersion
        
        if version.majorVersion >= 13 {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Settings. You can then close this app and get going!"
            openButton.title = "Open System Settings"
        } else {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Preferences. You can then close this app and get going!"
            openButton.title = "Open System Preferences"
        }
    }
    
    @IBAction func openSystemPreferences(_ sender: AnyObject) {
        NSWorkspace.shared.open(URL(fileURLWithPath:("/System/Library/PreferencePanes/Extensions.prefPane")
                                   ))
    }
    
    // MARK: - Main UI zoom management
    var isNotZoomed = true
    let originalSize = NSRect(x: 0, y: 0, width: 500, height: 350)

    func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame newFrame: NSRect) -> NSRect {
        var newFrame = isNotZoomed ? originalSize : NSRect(x: 0, y: 0, width: 500, height: 350)

        let screenRect = NSScreen.main!.visibleFrame
        let screenCenter = NSPoint(x: screenRect.midX, y: screenRect.midY)
        
        newFrame.origin.x = screenCenter.x - (newFrame.size.width / 2)
        newFrame.origin.y = screenCenter.y - (newFrame.size.height / 2)
        
        return newFrame
        }
}
