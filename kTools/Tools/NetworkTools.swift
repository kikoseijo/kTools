//
//  NetworkTools.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Foundation


func flushDNS() {
    NSAppleScript(source: "do shell script \"sudo killall -HUP mDNSResponder\" with administrator " +
        "privileges")!.executeAndReturnError(nil)
}
