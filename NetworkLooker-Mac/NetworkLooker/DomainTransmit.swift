//
//  DomainTransmit.swift
//  NetworkLooker
//
//  Created by wu on 2022/10/6.
//

import Foundation
import Socket
import WebKit

class DomainTransmiter {

    static let `default` = DomainTransmiter()
    weak var webview: WKWebView?
    
    
    func request(path: String, params: [String: Any], index: Int) {
        do {
            let socket = try Socket.create(family: .unix, type: .stream, proto: .tcp)
            try socket.connect(to: "/Users/wu/Downloads/my.sock")
            
            let queue = DispatchQueue.global(qos: .default)
            queue.async { [unowned self, socket] in
                var readData = Data(capacity: 4096)
                do {
                    
                    let body = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                    
                    // Write the welcome string...
                    try socket.write(from: "POST /\(path) HTTP/1.1\r\nHost:localhost\r\nContent-Length:\(body.count)\r\n\r\n\(String(data: body, encoding: .utf8)!)")
                    
                    let httpPraser = HttpResponseParser()
                    repeat {
                        let bytesRead = try socket.read(into: &readData)
                        if bytesRead > 0 {
                            
                            httpPraser.parse(data: readData)

                            if httpPraser.stage == .completed {
                                
                                print(bytesRead, readData.count)
                                
                                print(httpPraser.version)
                                print(httpPraser.header)
//                                print(httpPraser.body)
                                sendResponse(content: httpPraser.body, index: index, status: httpPraser.statusCode)
                                socket.close()
                                break
                            }
                        } else {
                            sendResponse(content: "", index: index, status: 500)
                            break
                        }
                    } while httpPraser.stage != .completed
                } catch {
                    sendResponse(content: "", index: index, status: 500)
                    print(error)
                }
            }
            
            
        } catch {
            print(error)
            sendResponse(content: "", index: index, status: 500)
        }
    }
    func sendResponse(content: String, index: Int, status: Int) {
        DispatchQueue.main.async {
            self.webview?.evaluateJavaScript("window.fetchCallback(\(content), \(index), \(status))")
        }
    }
}

class HttpResponseParser {
    
    var version: String = ""
    var statusCode: Int = -1
    var statusDes: String = ""
    var header: [String: String] = [:]
    var body: String = ""
    
    enum Stage {
        case version, statusCode, statusDes, lineEnd, headKey, headValue, body, chunkBodyNum, chunkBodyNumEnd, chunkBodyData, chunkBodyDataEnd, completed
    }
    
    var stage: Stage = .version
    
    
    var curDatas: Data = Data()
    var lineEndCount: Int = 0
    var headKey: String = ""
    var bodySize: Int64 = 0
    var chunkNumEndCount: Int = 0
    var chunkDataEndCount: Int = 0
    var chunkSize: Int = 0
    var bodyChunkData: Data = Data()
    func parse(data: Data) {
        data.enumerated().forEach { (item: EnumeratedSequence<Data>.Iterator.Element) in
            let ele: UInt8 = item.element
            
            switch stage {
            case .version:
                if (ele == 32) {
                    //空格
                    version = String.init(data: curDatas, encoding: .utf8) ?? ""
                    curDatas = Data()
                    stage = .statusCode
                    return
                }
                curDatas.append(ele)
            case .statusCode:
                if (ele == 32) {
                    let code = String.init(data: curDatas, encoding: .utf8) ?? ""
                    statusCode = Int(code) ?? 0
                    curDatas = Data()
                    stage = .statusDes
                    return
                }
                curDatas.append(ele)
            case .statusDes:
                if (ele == 13 || ele == 10) {
                    statusDes = String.init(data: curDatas, encoding: .utf8) ?? ""
                    curDatas = Data()
                    lineEndCount = 1
                    stage = .lineEnd
                    return
                }
                curDatas.append(ele)
            case .lineEnd:
                if (ele == 13 || ele == 10) {
                    lineEndCount += 1
                    if lineEndCount == 4 {
                        if let te = header["Transfer-Encoding"],
                            te == "chunked" {
                            stage = .chunkBodyNum
                            return
                        }

                        bodySize = Int64(header["Content-Length"] ?? "") ?? 0
                        if bodySize == 0 {
                            body = ""
                            curDatas = Data()
                            stage = .completed
                            return
                        }
                        stage = .body
                        
                    }
                } else {
                    stage = .headKey
                    curDatas.append(ele)
                }
            case .headKey:
                if (ele == 58) { //:
                    headKey = String.init(data: curDatas, encoding: .utf8) ?? ""
                    curDatas = Data()
                    stage = .headValue
                    return
                }
                curDatas.append(ele)
            case .headValue:
                if (ele == 13 || ele == 10) { //:
                    var value = String.init(data: curDatas, encoding: .utf8) ?? ""
                    value = value.trimmingCharacters(in: CharacterSet.whitespaces)
                    header[headKey] = value
                    curDatas = Data()
                    lineEndCount = 1
                    stage = .lineEnd
                    return
                }
                curDatas.append(ele)
            case .body:
                curDatas.append(ele)
                if curDatas.count >= bodySize {
                    body = String.init(data: curDatas, encoding: .utf8) ?? ""
                    curDatas = Data()
                    stage = .completed
                    return
                }
                break;
            case .chunkBodyNum:
                if (ele == 13 || ele == 10) { //:
                    let value = String.init(data: curDatas, encoding: .utf8) ?? ""
                    chunkSize = Int(value, radix: 16) ?? 0
                    curDatas = Data()
//                    print("chunkSize",value,chunkSize, ele)
                    chunkNumEndCount = 1
                    stage = .chunkBodyNumEnd
                    return
                }
                curDatas.append(ele)
                break
            case .chunkBodyNumEnd:
                
                if (ele == 13 || ele == 10) { //:
                    chunkNumEndCount += 1
//                    print("chunkNumEndCount",chunkNumEndCount, ele)
                    if chunkNumEndCount == 2 {
                        if chunkSize == 0 {
                            stage = .chunkBodyDataEnd
                        } else {
                            stage = .chunkBodyData
                        }
                    }
                }
                break
            case .chunkBodyData:
                bodyChunkData.append(ele)
                if bodyChunkData.count == chunkSize {
                    stage = .chunkBodyDataEnd
                }
                break
            case .chunkBodyDataEnd:
                if (ele == 13 || ele == 10) { //:
                    chunkDataEndCount += 1
//                    print("chunkDataEndCount",chunkDataEndCount, ele)
                    if chunkDataEndCount == 2 {
                        chunkDataEndCount = 0
                        print(ele, chunkSize)
                        if chunkSize == 0 {
                            body = String.init(data: bodyChunkData, encoding: .utf8) ?? ""
                            stage = .completed
                        } else {
                            stage = .chunkBodyNum
                        }
                    }
                }
                break
            default:
                break;
            }
        }
    }
}
