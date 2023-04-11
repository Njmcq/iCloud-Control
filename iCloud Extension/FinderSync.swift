//
//  FinderSync.swift
//  iCloud Extension
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022-2023 Nick McQuade. All rights reserved.
//

import Cocoa
import FinderSync
import Foundation
import UserNotifications

class FinderSync: FIFinderSync {
    
    let fm = FileManager.default
    let pasteboard = NSPasteboard.general
    
    var currentTargets: [URL] {
        var targets = FIFinderSyncController.default().selectedItemURLs() ?? []
        
        if let targetedUrl = FIFinderSyncController.default().targetedURL(), targets.count == 0 {
            targets.append(targetedUrl)
        }
        
        return targets
    }
    
    func functionError() {
        // Create a notification declaring that an error has occurred (for macOS 10.14 and above)
        if #available(macOS 10.14, *) {
            let content = UNMutableNotificationContent()
                content.title = "An error has occurred"
                content.body = "The selected action has not been completed."
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "funcError", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on macOS 10.13
            let notification = NSUserNotification()
            notification.title = "An error has occurred"
            notification.informativeText = "The selected action has not been completed."
            notification.soundName = NSUserNotificationDefaultSoundName
            let center = NSUserNotificationCenter.default
            center.deliver(notification)
        }
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "iCloud Control"
    }
    
    override var toolbarItemToolTip: String {
        return "Manually manage your files in iCloud Drive"
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
        print("'removeLocal' requested")
        
        for target in currentTargets {
            do {
                print("Local removal of \(target) requested")
                try fm.evictUbiquitousItem(at: target)
                print("Local removal of \(target) complete")
            } catch {
                print("Local removal of \(target) failed")
                functionError()
            }
        }
    }
    
    // Download items function
    @IBAction func downloadItem(_ sender: AnyObject?) {
        print("'downloadItem' requested")
        
        for target in currentTargets {
            do {
                print("Download of \(target) requested")
                try fm.startDownloadingUbiquitousItem(at: target)
                print("Download of \(target) complete")
            } catch {
                print("Download of \(target) failed")
                functionError()
            }
        }
    }
    
    // Publish items function
    @IBAction func publish(_ sender: AnyObject?) {
        var urls = [URL]()
        print("'publish' requested")
        
        for target in currentTargets {
                do {
                    print("Publishing of \(target) requested")
                    let url = try fm.url(forPublishingUbiquitousItemAt: target, expiration: nil)
                    urls.append(url)
                    print("Publishing of \(target) complete")
                } catch {
                    print("Publishing of \(target) failed")
                    functionError()
            }

            pasteboard.clearContents()
            pasteboard.writeObjects(urls as [NSPasteboardWriting])
            
            // Create a notification declaring that the link has been copied (for macOS 10.14 and above)
            if #available(macOS 10.14, *) {
                let content = UNMutableNotificationContent()
                if urls.count == 1 {
                    content.title = "Link copied to clipboard"
                    content.body = "1 link has been copied to the clipboard."
                } else if urls.count > 1 {
                    content.title = "Links copied to clipboard"
                    content.body = "\(urls.count) links have been copied to the clipboard."
                } else {
                    content.title = "No links found"
                    content.body = "No links were found in the selection."
                }
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "clipboardCopy", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            } else {
                // Fallback on macOS 10.13
                let notification = NSUserNotification()
                if urls.count == 1 {
                    notification.title = "1 link has been copied to clipboard"
                    notification.informativeText = "1 link has been copied to the clipboard."
                } else if urls.count > 1 {
                    notification.title = "\(urls.count) links have been copied to clipboard"
                    notification.informativeText = "\(urls.count) links have been copied to the clipboard"
                } else {
                    notification.title = "No links found"
                    notification.informativeText = "No links were found in the selection."
                }
                notification.soundName = NSUserNotificationDefaultSoundName
                
                let center = NSUserNotificationCenter.default
                center.deliver(notification)
            }
        }
    }
    
    // Exclude items function (.nosync)
    @IBAction func excludeItem(_ sender: AnyObject?) {
            print("'excludeItem' requested")
        
            for target in currentTargets {
                let name = target.lastPathComponent
                let parentUrl = target.deletingLastPathComponent()
                let noSyncUrl = URL(fileURLWithPath: "\(name).nosync", isDirectory: false, relativeTo: parentUrl)
                do {
                    print("Exclusion of \(target) requested")
                    try fm.moveItem(at: target, to: noSyncUrl)
                    print("Exclusion of \(target) complete")
                } catch {
                    print("Exclusion of \(target) failed")
                    functionError()
                }
            }
        }
    
    // Restore items function (undo .nosync)
    @IBAction func restoreItem(_ sender: AnyObject?) {
        print("'restoreItem' requested")
        
        for target in currentTargets {
            let name = target.lastPathComponent
            let parentUrl = target.deletingLastPathComponent()
            let originalUrl = URL(fileURLWithPath: name.replacingOccurrences(of: ".nosync", with: ""), isDirectory: false, relativeTo: parentUrl)
            do {
                print("Restore of \(target) requested")
                try fm.moveItem(at: target, to: originalUrl)
                print("Restore of \(target) complete")
            } catch {
                print("Restore of \(target) failed")
                functionError()
            }
        }
    }
}
