//
//  HelpViewController.swift
//  iCloud Control
//
//  Created by Nick McQuade on 25-02-23.
//  Copyright © 2016 Robbert Brandsma. All rights reserved.
//  Copyright © 2023 Nick McQuade. All rights reserved.

import Cocoa
import WebKit

class HelpViewController: NSViewController {

    @IBOutlet weak var helpWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Load README page in the ViewController WebView
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control#installation--help") {
            let request = URLRequest(url: url)
            helpWebView.load(request)
        } else {
            // This alert will be replaced with an identical string by the system, but I've left it here as a contingency.
            showAlert(message: "The Internet connection appears to be offline.")
        }
        
        helpWebView.navigationDelegate = self
    }
    // MARK: - Show alert if internet connection is unavailable.
    private func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = "Check your connection and try again."
        alert.runModal()
    }
}

extension HelpViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showAlert(message: error.localizedDescription)
    }
}
