//
//  AppDelegate.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022-2023 Nick McQuade. All rights reserved.

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Simple function which forces the app to terminate when the last window is closed by the user
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    // MARK: - Notification authorisation permissions & alert
        
        func requestAuthorisation() {
            if #available(macOS 10.14, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.getNotificationSettings { (settings) in
                    switch settings.authorizationStatus {
                    case .authorized:
                        print("Notifications already authorised.")
                    case .denied:
                        print("Notifications denied by user.")
                    case .notDetermined:
                        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                            if granted {
                                print("Notifications authorisation granted.")
                            }
                        }
                        NSApplication.shared.registerForRemoteNotifications()
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.messageText = "Notifications Required"
                            alert.informativeText = "iCloud Control requires notification permissions in order to deliver alerts when an action has been completed, or has failed."
                            alert.addButton(withTitle: "Open Notifications")
                            alert.addButton(withTitle: "Dismiss")
                            alert.alertStyle = .informational
                            let response = alert.runModal()
                            if response == .alertFirstButtonReturn {
                                NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Notifications.prefPane"))
                            }
                        }
                    case .provisional:
                        print("Notifications provisionally authorised.")
                    @unknown default:
                        print("Unknown authorisation status.")
                    }
                }
            } else {
                let defaults = UserDefaults.standard
                
                // Check if the flag indicating whether the alert has been displayed is set to true
                if defaults.bool(forKey: "alertDisplayed") {
                    // Alert has already been displayed, do nothing
                    return
                }
                let alert = NSAlert()
                alert.messageText = "Notifications not supported"
                alert.informativeText = "iCloud Control does not support notifications on macOS 10.13."
                alert.addButton(withTitle: "Dismiss")
                alert.alertStyle = .informational
                alert.runModal()
                defaults.set(true, forKey: "alertDisplayed")
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        requestAuthorisation()
    }

    @IBAction func openLatestRelease(_ sender: Any) {
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control/releases/latest") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @IBAction func helpMenuItem(_ sender: NSMenuItem) {
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control#installation--help") {
            NSWorkspace.shared.open(url)
        }
    }
    
    // MARK: - Check For Updates function
    @IBAction func checkForUpdates(_ sender: Any) {
        let owner = "Njmcq"
        let repo = "iCloud-Control"
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/releases/latest")

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP response status code")
                return
            }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let tagName = json["tag_name"] as? String,
               let downloadURLString = json["html_url"] as? String {
                let downloadURL = URL(string: downloadURLString)!

                if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    if currentVersion.compare(tagName, options: .numeric) == .orderedDescending {
                        // Current version is higher than the latest release
                        self.showTestingVersionAlert(currentVersion: currentVersion)
                    } else if currentVersion.compare(tagName, options: .numeric) == .orderedAscending {
                        // A new update is available
                        let releaseNotes = json["body"] as? String ?? ""
                        self.showAlertWithUpdate(version: tagName, releaseNotes: releaseNotes, downloadURL: downloadURL)
                    } else {
                        // Current version is equal to the latest release
                        self.showLatestVersionInstalledAlert()
                    }
                }
            }
        }

        task.resume()
    }

    func showAlertWithUpdate(version: String, releaseNotes: String, downloadURL: URL) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "A new update is available"
            alert.informativeText = "Version \(version) is now available. Do you want to download it? \n(This will open GitHub in your browser)"
            alert.addButton(withTitle: "Download")
            alert.addButton(withTitle: "View Release Notes")
            alert.addButton(withTitle: "Cancel")
            
            let modalResult = alert.runModal()
            if modalResult == NSApplication.ModalResponse.alertFirstButtonReturn {
                // Download button pressed
                NSWorkspace.shared.open(downloadURL)
            } else if modalResult == NSApplication.ModalResponse.alertSecondButtonReturn {
                // View Release Notes button pressed
                // Implement the action you want to perform here
                // For example, open a window or display the release notes in a text view
                NSWorkspace.shared.open(downloadURL)
            }
        }
    }


    func showLatestVersionInstalledAlert() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "You have the latest version installed"
            alert.informativeText = "You are already running the latest version of the app."
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    func showTestingVersionAlert(currentVersion: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "You have a higher version installed"
            alert.informativeText = "You are running version \(currentVersion), which is higher than the latest release."
            alert.addButton(withTitle: "View Latest Release")
            alert.addButton(withTitle: "OK")
            let modalResult = alert.runModal()
            
            if modalResult == NSApplication.ModalResponse.alertFirstButtonReturn {
                // View Latest Release button pressed
                let owner = "Njmcq"
                let repo = "iCloud-Control"
                let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/releases/latest")
                
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Error: Invalid HTTP response status code")
                        return
                    }
                    
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let tagName = json["tag_name"] as? String,
                       let downloadURLString = json["html_url"] as? String {
                        let downloadURL = URL(string: downloadURLString)!
                        
                        self.showAlertWithUpdate(version: tagName, releaseNotes: "", downloadURL: downloadURL)
                    }
                }
                
                task.resume()
            }
        }
    }
}
