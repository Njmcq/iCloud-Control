//
//  ViewController.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022-2023 Nick McQuade. All rights reserved.

import Foundation
import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var greetingLabel: NSTextField!
    @IBOutlet weak var explainLabel: NSTextField!
    @IBOutlet weak var openButton: NSButton!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //MARK: - Change window behaviour
        // Set the window behavior to zoom instead of maximize
        view.window?.collectionBehavior = .fullScreenNone
        view.window?.delegate = self
        
        // Hide the title of the window
        view.window?.titleVisibility = .hidden
        
        // Disable the transparent appearance of the title bar
        view.window?.titlebarAppearsTransparent = true
        
        // MARK: - Adjust greeting label based on time of day
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 0 && hour < 12 {
            greetingLabel.stringValue = "Good morning!"
        } else if hour >= 12 && hour < 18 {
            greetingLabel.stringValue = "Good afternoon!"
        } else {
            greetingLabel.stringValue = "Good evening!"
        }
        
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
    
    @IBAction func openSystemSettings(_ sender: AnyObject) {
        NSWorkspace.shared.open(URL(fileURLWithPath:("/System/Library/PreferencePanes/Extensions.prefPane")))
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
