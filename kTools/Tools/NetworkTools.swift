//
//  NetworkTools.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa


func flushDNS() {
    NSAppleScript(source: "do shell script \"sudo killall -HUP mDNSResponder\" with administrator " +
        "privileges")!.executeAndReturnError(nil)
}

func openUrlOnBrowser(_ urlString:String){
    let cleanURL = addHttpIfNotFound(urlString)
    if let url = URL(string: cleanURL), NSWorkspace.shared().open(url) {
        
    } else {
        print("Trying to open invalid urlString: \(urlString)")
    }
}

func addHttpIfNotFound(_ stringUrl: String) -> String{
    if (stringUrl.lowercased().range(of: "http://") != nil || stringUrl.lowercased().range(of: "https://") != nil) {
        return stringUrl
    } else {
        return "http://\(stringUrl)"
    }
}
