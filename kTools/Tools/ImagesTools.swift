//
//  ImagesTools.swift
//  kTools
//
//  Created by sMac on 18/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa


func tintedImage(_ image: NSImage, tint: NSColor) -> NSImage {
    guard let tinted = image.copy() as? NSImage else { return image }
    tinted.lockFocus()
    tint.set()
    
    let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
    imageRect.fill(using: .sourceAtop)
    
    tinted.unlockFocus()
    return tinted
}
