//
//  FinderSync.swift
//  iCloudExtension
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2023 Nick McQuade. All rights reserved.
//

import Cocoa
import FinderSync
import Foundation

class FinderSync: FIFinderSync {
    
    let fm = FileManager.default
    
    var currentTargets: [URL] {
        var targets = FIFinderSyncController.default().selectedItemURLs() ?? []
        
        if let targetedUrl = FIFinderSyncController.default().targetedURL(), targets.count == 0 {
            targets.append(targetedUrl)
        }
        
        return targets
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "iCloud Control"
    }
    
    override var toolbarItemToolTip: String {
        return "Manually manage iCloud storage"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: "CloudToolbarIcon")!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        NSLog("menu(for:)")
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "Remove selected items locally", action: #selector(removeLocal(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Download selected items", action: #selector(downloadItem(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Publish public link", action: #selector(publish(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Exclude selected items from iCloud", action: #selector(excludeItem(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Restore selected items", action: #selector(restoreItem(_:)), keyEquivalent: "")
        
        return menu
    }

    // Remove local items function
    @IBAction func removeLocal(_ sender: AnyObject?) {
        NSLog("removeLocal")

        for target in currentTargets {
            NSLog("Local removal of \(target) requested")
            do {
                try fm.evictUbiquitousItem(at: target)
                NSLog("Removal of \(target) succeeded")
            } catch {
                NSLog("Removal of \(target) failed with error \(error)")
            }
        }
    }
    
    // Download items function
    @IBAction func downloadItem(_ sender: AnyObject?) {
        NSLog("Download requested")
        
        for target in currentTargets {
            NSLog("Download of \(target) requested")
            do {
                try fm.startDownloadingUbiquitousItem(at: target)
                NSLog("Download of \(target) succeeded")
            } catch {
                NSLog("Download of \(target) failed with error \(error)")
            }
        }
    }
    
    // Publish items function (iCloud URL share)
    @IBAction func publish(_ sender: AnyObject?) {
        var urls = [URL]()
        
        for target in currentTargets {
            NSLog("Publishing \(target) requested")
            do {
                let url = try fm.url(forPublishingUbiquitousItemAt: target, expiration: nil)
                NSLog("Publishing \(target) succeeded, url: \(url)")
                urls.append(url)
            } catch {
                NSLog("Publishing \(target) failed with error \(error)")
            }
        }
        
        let pb = NSPasteboard.general
        pb.clearContents()
        
        pb.writeObjects(urls as [NSPasteboardWriting])
    }
    
    // Exclude items function (.nosync)
    @IBAction func excludeItem(_ sender: AnyObject?) {
        NSLog("Exclude requested")
        
            for target in currentTargets {
                let name = target.lastPathComponent
                let parentUrl = target.deletingLastPathComponent()
                let noSyncUrl = URL(fileURLWithPath: "\(name).nosync", isDirectory: false, relativeTo: parentUrl)
                do {
                    try fm.moveItem(at: target, to: noSyncUrl)
                } catch {
                    NSLog("Exclude of \(target) failed with error \(error)")
                }
            }
        }
    
    // Restore items function (undo .nosync)
    @IBAction func restoreItem(_ sender: AnyObject?) {
        NSLog("Restore requested")
        for target in currentTargets {
            let name = target.lastPathComponent
            let parentUrl = target.deletingLastPathComponent()
            let originalUrl = URL(fileURLWithPath: name.replacingOccurrences(of: ".nosync", with: ""), isDirectory: false, relativeTo: parentUrl)
            do {
                try fm.moveItem(at: target, to: originalUrl)
            } catch {
                NSLog("Restore of \(target) failed with error \(error)")
            }
        }
    }
}
