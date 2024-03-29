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
    
    
    var sockPath: NSString = ""
    var configPath: NSString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return
        }

        // Swift Strings
        sockPath = "\(document)/sock.sock" as NSString
        configPath = "\(document)/config.json" as NSString
        
        
        DomainTransmiter.default.webview = webView
        DomainTransmiter.default.sockPath = sockPath as String

        let delegateController = WKWebViewDelegateController()
        delegateController.webview = webView
        webView.configuration.userContentController.add(delegateController, name: "htmlMethods")
        
//        loadFromDebug()
        loadFromBundle()
        
        
        
        
        DispatchQueue.global().async {
            // Convert the Swift strings to CChars (or Int8) that map to
            let sockPathToC = UnsafeMutablePointer<CChar>(mutating: self.sockPath.utf8String)
            let configPathToC = UnsafeMutablePointer<CChar>(mutating: self.configPath.utf8String)
            start(sockPathToC, configPathToC)
        }
    }
    
    func loadFromBundle() {
        let indexpath = Bundle.main.path(forResource: "index", ofType: "html")
        let jspath = Bundle.main.path(forResource: "app.bundle", ofType: "js")
        let content = try! String.init(contentsOf: URL.init(fileURLWithPath: indexpath!))
        let jscontent = try! String.init(contentsOf: URL.init(fileURLWithPath: jspath!))
//        content = content + "<script>" + jscontent + "</script>"
        webView.configuration.userContentController.addUserScript(WKUserScript.init(source: jscontent, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    func loadFromDebug() {
        webView.load(URLRequest(url: URL(string: "http://localhost:8000/")!))
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
    
    weak var webview: WKWebView?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any],
           let cmd = body["cmd"] as? String
        {
            switch cmd {
            case "request":
                if let index = body["index"] as? Int,
                    let path = body["path"] as? String,
                   let params = body["params"] as? [String: Any],
                   let method = body["method"] as? String{
                    DomainTransmiter.default.request(path: path, method: method, params: params, index: index)
                }
                break;
            default:
                break;
            }
        }
    }
}
