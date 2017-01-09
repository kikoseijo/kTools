//
//  Project.swift
//  kTools
//
//  Created by sMac on 04/01/2017.
//  Copyright © 2017 Sunnyface.com. All rights reserved.
//

import Foundation


class Project : NSObject {
    var name: String = ""
    var type: String = ""
    var lPath: String = ""
    var rPath: String = ""
    var lUrl: String = ""
    var rUrl: String = ""
    var gitCommand: String = ""
}

extension Project {
    
    class func createProjectFrom(dicc: [String: Any])->Project {
        let project = Project()

        project.name = dicc["name"] as! String? ?? ""
        project.lPath = dicc["localPath"] as! String? ?? ""
        project.type = dicc["type"] as! String? ?? ""
        project.rPath = dicc["remotePath"] as! String? ?? ""
        project.lUrl = dicc["lUrl"] as! String? ?? ""
        project.rUrl = dicc["rUrl"] as! String? ?? ""
        project.gitCommand = dicc["gitCommand"] as! String? ?? ""
        
        return project
    }
    
    class func toDictionary() -> Dictionary<String, Any> {
        
        let gelato = [
            "Coconut":0.25,
            "Pistachio":0.26,
            "Stracciatella":0.02,
            "Chocolate":0.03,
            "Peanut Butter":0.01,
            "Bubble Gum":0.01
        ]
        
        return gelato
    }
    
}
