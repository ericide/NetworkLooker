//
//  ViewController.swift
//  NetworkLooker
//
//  Created by Eric on 2022/10/6.
//

import Cocoa
import WebKit
import Socket

class ViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let socket = try Socket.create(family: .unix, type: .stream, proto: .tcp)
            print("1")
            try socket.connect(to: "/Users/wu/Downloads/my.sock")
            print("2")
            
            let queue = DispatchQueue.global(qos: .default)
            queue.async { [unowned self, socket] in
                var readData = Data(capacity: 4096)
                do {
                                // Write the welcome string...
                                try socket.write(from: "GET /?key=value&key=value HTTP/1.1\nHost:www.baidu.com\nAccept-Language: zh-CN,zh;q=0.9\n\r\n\r")
                                
                                repeat {
                                    let bytesRead = try socket.read(into: &readData)
                                    if bytesRead > 0 {
                                        guard let response = String(data: readData, encoding: .utf8) else {
                                            
                                            print("Error decoding response...")
                                            readData.count = 0
                                            break
                                        }
                                        print(response)
                                    } else {
                                        break
                                    }
                                } while true
                } catch {
                    print(error)
                }
            }
            
            
        } catch {
            print(error)
        }
        

        
        let delegateController = WKWebViewDelegateController()

//        [userContentController addScriptMessageHandler:delegateController  name:@"htmlMethods"];
        webView.configuration.userContentController.add(delegateController, name: "htmlMethods")
        
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")

        
        let content = try! String.init(contentsOf: URL.init(fileURLWithPath: path!))
        
//        webView.loadHTMLString(content, baseURL: nil)
        webView.load(URLRequest(url: URL(string: "http://localhost:3000/")!))
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
