//
//  CommandLine.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

let ENV = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local",
             "HOME": ProcessInfo.processInfo.environment["HOME"]!,
             "LANG": "en_CA.UTF-8"]

class Commander {
    
    func whichPath (executable: String) -> String {
        guard !executable.characters.contains("/") else {
            return executable
        }
        let findCommand = "/usr/bin/which \(executable)"
        let out = findCommand.runAsCommand()
        return out.isEmpty ? executable : out
    }
    
    public func runAndPrint(comandToRun: String, textView: NSTextView) {
        let output = comandToRun.runAsCommand()
        let fullOutput = "$ " + comandToRun + "\n" + output
        textView.append(string: fullOutput);
    }
    
    func launchTerminalWith(command:String) {
        var outputAttributes: NSDictionary? = nil
        NSAppleScript(source: "if application \"Terminal\" is running then\ntell application \"Terminal\" do script \"echo HELLO\"\nactivate\nend tell\nelse\ntell application \"Terminale\"\ndo script \"echo Heelllo\" in window 1\nactivate\nend tell\nend if")!.executeAndReturnError(&outputAttributes)
        NSAppleScript(source: "tell application \"Terminal\" do script \"\(command)\"\nactivate")!.executeAndReturnError(&outputAttributes)
        NSLog((outputAttributes?.description)!)
    }
    
    func run(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.environment = ENV
        task.launchPath = cmd
        task.arguments = args
        //task.currentDirectoryPath = "/usr/local/bin"
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
    
}


extension String {
    func runAsCommand() -> String {
        let pipe = Pipe()
        let task = Process()
        let env = ProcessInfo.processInfo.environment as [String: String]
        task.environment = ENV
        task.launchPath = env["SHELL"]! //env["PATH"]!
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        }
        else {
            return "--- Error running command - Unable to initialize string from file data ---"
        }
    }
}
