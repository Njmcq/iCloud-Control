//
//  WindowController.swift
//  iCloud Control
//
//  Created by Nick McQuade on 25/2/2023.
//  Copyright © 2023 Nick McQuade. All rights reserved.
//

import Foundation
import AppKit

class MyWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        guard let window = self.window else { return }
        
        // Get the current size of the window
        let currentSize = window.frame.size
        
        // Set the desired aspect ratio of the window
        let aspectRatio = NSSize(width: 10, height: 9)
        
        // Calculate the new size of the window based on the aspect ratio
        var newSize = currentSize
        newSize.width = aspectRatio.height * currentSize.width / currentSize.height
        
        // Check if the new size fits within the screen bounds
        if let screenFrame = window.screen?.visibleFrame {
            if newSize.width > screenFrame.width || newSize.height > screenFrame.height {
                // If the new size is too large, adjust it to fit within the screen bounds
                newSize.width = min(newSize.width, screenFrame.width)
                newSize.height = min(newSize.height, screenFrame.height)
                newSize.width = aspectRatio.height * newSize.height / aspectRatio.width
            }
        }
        
        // Set the new size of the window
        window.setFrame(NSRect(origin: window.frame.origin, size: newSize), display: true)
    }

    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        // Disable the user from resizing the window from the sides
        let currentSize = sender.frame.size
        let size = NSSize(width: frameSize.width, height: currentSize.height)
        return size
    }
}

