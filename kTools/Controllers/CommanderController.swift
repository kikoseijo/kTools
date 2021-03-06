//
//  SshViewController.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class CommanderController: NSViewController {

    private let cmd = Commander()
    private let brewPath = ExecPaths.atom.rawValue
    
    @IBAction func actionKnown_host(_ sender: NSButton)
    {
        let command = "\(brewPath) ~/.ssh/known_hosts"
        cmd.runAndPrint(comandToRun: command, textView: sshTextView)
    }
    
    @IBAction func editNginxConf(_ sender: NSButton)
    {
        let command = "\(brewPath) /usr/local/etc/nginx/nginx.conf"
        cmd.runAndPrint(comandToRun: command, textView: sshTextView)
    }
    
    @IBAction func copyPubKey(_ sender: NSButton)
    {
        let command = "cat ~/.ssh/id_rsa.pub | pbcopy"
        cmd.runAndPrint(comandToRun: command, textView: sshTextView)
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
    
    @IBAction func openProgramDataFolder(_ sender: NSButton) {
        
        
        let fileManager = FileManager.default
        let dir = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        let appFolder = (dir as NSString).appendingPathComponent("\(App.name.rawValue)")
        var isDir: ObjCBool = false
        if false == fileManager.fileExists(atPath: appFolder, isDirectory: &isDir) {
            do {
                try fileManager.createDirectory(atPath: appFolder, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        let command = "open \"\(appFolder)\""
        cmd.runAndPrint(comandToRun: command, textView: sshTextView)
        
        //print(appFolder)
    }
    
    //MARK:  Run Command
    
    @IBOutlet var sshTextView: NSTextView!
    @IBOutlet weak var runAsSudo: NSButton!
    @IBOutlet weak var execCommandTF: NSTextField!
    @IBOutlet weak var execCommandSpinner: NSProgressIndicator!
    @IBOutlet weak var execCommandBtn: NSButton!
    
    private func runManualcommand(){
        var command = execCommandTF.stringValue
        if runAsSudo.state.rawValue == 1 {
            command = "sudo " + command
        }
        execCommandSpinner.startAnimation(self)
        cmd.runAndPrint(comandToRun: command, textView: sshTextView)
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

