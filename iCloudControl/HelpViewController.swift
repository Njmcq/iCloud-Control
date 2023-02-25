//
//  ViewController.swift
//  iCloudControl
//
//  Created by Robbert Brandsma on 30-06-16.
//  Updated by Nick McQuade on 04-01-22.
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
