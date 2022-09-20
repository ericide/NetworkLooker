//
//  DataParser.swift
//  Watcher
//
//  Created by wu on 2022/1/28.
//  Copyright © 2022 Hp. All rights reserved.
//

import Cocoa

@objc class DataParserManager: NSObject {
    private let lock = NSLock()
    @objc static var shared = DataParserManager()
    
    var tunnels: Dictionary<Int, DataParser> = [:]
    
    @objc func addData(dir: Int,identity: Int, data: Data) {
        lock.lock()
        if (tunnels[identity] == nil) {
            tunnels[identity] = DataParser(identity: identity)
        }
        let parse = tunnels[identity]!
        lock.unlock()
        parse.addData(dir: dir, data: data)
        
    }
    
}



class DataParser: NSObject {
    
    let identity: Int
    var parse = HttpParser()
    
    init( identity: Int) {
        self.identity = identity
    }
    
    func addData(dir: Int, data: Data) {
        if dir == 0 {
            parse.addRequestData(data: data)
        } else {
            parse.addResponseData(data: data)
        }
    }
}
class HttpParser: NSObject {
    
    var reqData: Data = Data()
    var reqState = 0;
    var reqPos = 0;
    
    var method = ""
    var uri = ""
    var proto = ""
    
    var resData: Data = Data()
    
    
    func addRequestData(data: Data) {
        reqData.append(data)
        
        switch reqState {
        case 0:
            for i in reqPos...(reqData.count-2) {
                let value1 = reqData[i]
                let value2 = reqData[i+1]
                if value1 == 13, value2 == 10 {
                    if let s = String.init(data: reqData[reqPos...(i-1)], encoding: .utf8) {
                        
                        let arr = s.split(separator: " ")
                        method = String(arr[0])
                        uri = String(arr[1])
                        proto = String(arr[2])
                        
                        print("method \(method), uri: \(uri), proto: \(proto)")
                    }
                    reqPos = i + 2
                    reqState = 1
                    break;
                }
            }
        default:
            print("");
        }
        
        
        
        
        
        print("request")
    }
    func addResponseData(data: Data) {
        resData.append(data)
        print("response")
    }
}
