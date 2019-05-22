//
//  WebViewController.swift
//  QRCodeScanner
//
//  Created by Bibek on 5/19/19.
//  Copyright © 2019 ARtech. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet var webView : UIWebView!
    
    var url = URL(string : "https://www.google.com")

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlreq = URLRequest(url: url!)
        webView.loadRequest(urlreq)
        
        // Do any additional setup after loading the view.
    }
    


}
