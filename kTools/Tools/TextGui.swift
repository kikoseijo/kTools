//
//  TextGui.swift
//  kTools
//
//  Created by sMac on 18/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa


extension NSTextView {
    func append(string: String) {
        
        let color = NSColor.white
        let attrs = [NSForegroundColorAttributeName : color]
        let newLineString = string
        self.textStorage?.append(NSAttributedString(string: newLineString, attributes: attrs))
        self.scrollToEndOfDocument(nil)
    }
}

func alertWithPrompt(onWindow: NSWindow, title: String, infoText:String, acceptText: String = "Add", cancelText:String = "Cancel" ) -> String {
    
    let prompt = NSTextField(frame: NSMakeRect(0,0,260,20))
    
    let alert = NSAlert()
    alert.messageText = title
    alert.accessoryView = prompt
    alert.addButton(withTitle: acceptText)
    alert.addButton(withTitle: cancelText)
    alert.informativeText = infoText
    
    var returnValue = ""
    alert.beginSheetModal(for: onWindow, completionHandler: {  (returnCode) -> Void in
        if returnCode == NSAlertFirstButtonReturn {
            returnValue =  prompt.stringValue
        }
    })
    
    return returnValue
}
