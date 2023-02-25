//
//  HelpViewController.swift
//  iCloudControl
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
        
        if let url = URL(string: "https://github.com/Njmcq/iCloud-Control#installation--help") {
            let request = URLRequest(url: url)
            helpWebView.load(request)
        }
    }
}
