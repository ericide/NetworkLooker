//
//  ViewController.swift
//  NetworkLooker
//
//  Created by Eric on 2022/10/6.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        let delegateController = WKWebViewDelegateController()

//        [userContentController addScriptMessageHandler:delegateController  name:@"htmlMethods"];
        webView.configuration.userContentController.add(delegateController, name: "htmlMethods")
        
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")

        
        let content = try! String.init(contentsOf: URL.init(fileURLWithPath: path!))
        
        webView.loadHTMLString(content, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "htmlMethods")
    }

}

class WKWebViewDelegateController: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any],
           let cmd = body["cmd"] as? String,
           cmd == "start"
        {
            DispatchQueue.global().async {
                start()
            }
        }
        
        print(message.body)
        print(message.name)
    }
}
