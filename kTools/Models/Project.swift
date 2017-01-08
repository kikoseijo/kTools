//
//  Project.swift
//  kTools
//
//  Created by sMac on 04/01/2017.
//  Copyright © 2017 Sunnyface.com. All rights reserved.
//

import Foundation


class Project:NSObject {
    var name: String = ""
    var type: String = ""
    var lPath: String = ""
    var rPath: String = ""
    var gitCommand: String = ""
}

extension Project {
    
    
    class func createProjectFrom(dicc: [String: Any])->Project {
        let project = Project()
        // Required
        project.name = (dicc["name"] as? String)!
        project.lPath = (dicc["localPath"] as? String)!
        project.type = (dicc["type"] as? String)!
        project.rPath = dicc["remotePath"] as! String? ?? ""
        project.gitCommand = dicc["gitCommand"] as! String? ?? ""
       return project
    }
}
