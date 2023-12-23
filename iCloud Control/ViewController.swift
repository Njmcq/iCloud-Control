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
        updateGreetingLabel() // This sets the Greeting Label in the ViewController when the app is launched, even if it isn't the foreground app.
        
        //MARK: - Change window behaviour

        // Hide the title of the window
        view.window?.titleVisibility = .hidden
        
        // Disable the transparent appearance of the title bar
        view.window?.titlebarAppearsTransparent = true
        
        // Set the window styleMask to include .fullSizeContentView
        view.window?.styleMask.insert(.fullSizeContentView)
        
        // Disable the Maximise/Zoom button in the window
        view.window?.styleMask.remove(.resizable)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGreetingLabel), name: NSApplication.willBecomeActiveNotification, object: nil)
            
        // MARK: - Change UI based on OS version
        let version = ProcessInfo.processInfo.operatingSystemVersion
        
        if version.majorVersion >= 13 {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Settings. You can then close this app and get going!"
            openButton.title = "Open System Settings"
            print("'Explain Label' and 'Open Button' successfully updated with the System Settings text.")
        } else {
            explainLabel.stringValue = "To get started, enable the iCloud Control Finder extension in System Preferences. You can then close this app and get going!"
            openButton.title = "Open System Preferences"
            print("'Explain Label' and 'Open Button' successfully updated with the System Preferences text.")
        }
    }
    
    @IBAction func openSystemSettings(_ sender: AnyObject) {
        NSWorkspace.shared.open(URL(fileURLWithPath:("/System/Library/PreferencePanes/Extensions.prefPane")))
    }
    
    @IBAction func helpButton(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control#installation--help") {
            NSWorkspace.shared.open(url)
        }
    }
    
    // MARK: - Adjust greeting label based on time of day
    @objc func updateGreetingLabel() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 0 && hour < 12 {
            greetingLabel.stringValue = "Good morning!"
            print("'Greeting Label' successfully updated with \"Good morning!\"")
        } else if hour >= 12 && hour < 18 {
            greetingLabel.stringValue = "Good afternoon!"
            print("'Greeting Label' successfully updated with \"Good afternoon!\"")
        } else {
            greetingLabel.stringValue = "Good evening!"
            print("'Greeting Label' successfully updated with \"Good evening!\"")
        }
    }
}
