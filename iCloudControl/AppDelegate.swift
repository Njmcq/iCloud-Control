//
//  AppDelegate.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022 Nick McQuade. All rights reserved.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    @IBAction func openLatestRelease(_ sender: Any) {
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control/releases/latest") {
            NSWorkspace.shared.open(url)
        }
    }

    
}

