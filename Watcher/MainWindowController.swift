//
//  MainWindowController.swift
//  Watcher
//
//  Created by wu on 2022/1/27.
//  Copyright © 2022 Hp. All rights reserved.
//

import Cocoa

@objc class MainWindowController: NSWindowController {

    var isStart: Bool = false
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var serverBtn: NSButton!
    
    @IBAction func serverBtnClick(_ sender: Any) {
        
        if (isStart) {
            stop();
            self.serverBtn.image =  NSImage.init(named: "power_button_off")
            self.isStart = false
        } else {
            DispatchQueue.global().async {
                start();
            }
            self.isStart = true
            self.serverBtn.image = NSImage.init(named: "power_button_on")
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        print("aaaa")
        // Do view setup here.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.serverBtn.image = NSImage.init(named: "power_button_off")
        
    }
    
    override var windowNibName: NSNib.Name? {
        get {
            return "MainWindowController"
        }
    }
    
}
extension MainWindowController: NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
}

extension MainWindowController: NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return tableColumn?.identifier 
    }
}