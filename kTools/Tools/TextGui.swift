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
        let attrs = [NSAttributedStringKey.foregroundColor : color]
        let newLineString = string
        self.textStorage?.append(NSAttributedString(string: newLineString, attributes: attrs))
        self.scrollToEndOfDocument(nil)
    }
}
