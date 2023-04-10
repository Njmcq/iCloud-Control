//
//  AppDelegate.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2022-2023 Nick McQuade. All rights reserved.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // Simple function which forces the app to terminate when the last window is closed by the user
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    @IBAction func openLatestRelease(_ sender: Any) {
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control/releases/latest") {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - Check For Updates function
    @IBAction func checkForUpdates(_ sender: Any) {
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
                
                let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                
                if currentVersion.compare(tagName, options: .numeric) == .orderedAscending {
                    // A new update is available
                    let releaseNotes = json["body"] as? String ?? ""
                    self.showAlertWithUpdate(version: tagName, releaseNotes: releaseNotes, downloadURL: downloadURL)
                } else {
                    // No updates are available
                    self.showLatestVersionInstalledAlert()
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
            alert.addButton(withTitle: "Cancel")
            
            let modalResult = alert.runModal()
            if modalResult == NSApplication.ModalResponse.alertFirstButtonReturn {
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
    }
