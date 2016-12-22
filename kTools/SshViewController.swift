//
//  SshViewController.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class SshViewController: NSViewController {

    private let commander = Commander()
    
    @IBAction func actionKnown_host(_ sender: NSButton)
    {
        let command = "/usr/local/bin/atom ~/.ssh/known_hosts"
        commander.run(comandToRun: command, textView: sshTextView)
    }
    
    @IBAction func editNginxConf(_ sender: NSButton)
    {
        let command = "/usr/local/bin/atom /usr/local/etc/nginx/nginx.conf"
        commander.run(comandToRun: command, textView: sshTextView)
    }
    

    
    @IBAction func testFunction(_ sender: NSButton) {
        let fileManager = FileManager.default
        let path = fileManager.currentDirectoryPath
        sshTextView.append(string: path)
    }
    
    @IBAction func flushDnsCache(_ sender: NSButton) {
        // NSAppleScript(source: "do shell script \"sudo killall -HUP mDNSResponder\" with administrator " +
        //    "privileges")!.executeAndReturnError(nil)
        flushDNS()
    }
    
    
    //MARK:  Run Command
    
    @IBOutlet var sshTextView: NSTextView!
    @IBOutlet weak var runAsSudo: NSButton!
    @IBOutlet weak var execCommandTF: NSTextField!
    @IBOutlet weak var execCommandSpinner: NSProgressIndicator!
    @IBOutlet weak var execCommandBtn: NSButton!
    
    private func runManualcommand(){
        var command = execCommandTF.stringValue
        if runAsSudo.state == 1 {
            command = "sudo " + command
        }
        execCommandSpinner.startAnimation(self)
        commander.run(comandToRun: command, textView: sshTextView)
        execCommandSpinner.stopAnimation(self)
    }
    
    @IBAction func commandFieldAction(sender: NSTextField) {
        runManualcommand()
    }
    
    @IBAction func execCommandAction(_ sender: NSButton) {
        runManualcommand()
    }
    
    //MARK:  LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sshTextView.insertionPointColor = NSColor.white
        sshTextView.textColor = NSColor.white
        sshTextView.textStorage?.foregroundColor = NSColor.black
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

