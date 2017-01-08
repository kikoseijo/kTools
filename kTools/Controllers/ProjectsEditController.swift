//
//  ProjectsEditController.swift
//  kTools
//
//  Created by sMac on 08/01/2017.
//  Copyright © 2017 Sunnyface.com. All rights reserved.
//

import Cocoa

class ProjectsEditController: NSViewController {
    
    public var project:Project = Project()
    public var projectIndex: Int = -1
    
    private var projectTypeSources = ["Laravel", "xCode", "Mean", "Wordpress", "Android", "C++"]
    let dbManager = PlistManager.sharedInstance
    var projects: Array<Dictionary<String, String>> = []
    
    @IBOutlet weak var nameTf: NSTextField!
    @IBOutlet weak var lPathTf: NSTextField!
    @IBOutlet weak var rPathTf: NSTextField!
    @IBOutlet weak var typePf: NSPopUpButton!
    @IBOutlet weak var saveBtn: NSButton!
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePf.addItems(withTitles: projectTypeSources)
        
        if project.name != "" {
            nameTf.stringValue = project.name
            lPathTf.stringValue = project.lPath
            rPathTf.stringValue = project.rPath
            typePf.selectItem(withTitle: project.type)
        }
    }
    
    override func viewWillAppear() {
        
       projects = dbManager.getValueForKey(key: "LaraProjects") as! Array<Dictionary<String, String>>
        
    }
    
    @IBAction func saveProject(_ sender: NSButton) {
        
        let tipo = typePf.selectedItem?.title
        
        project.name = nameTf.stringValue
        project.lPath = lPathTf.stringValue
        project.rPath = rPathTf.stringValue
        project.type = tipo!
        
        let newProject: [String:String] = [
            "name" : nameTf.stringValue,
            "type" : tipo!,
            "localPath" : lPathTf.stringValue,
            "remotePath" : rPathTf.stringValue,
            ]
        
        var is_new:Bool = false
        if (project.name != ""){
            projects[projectIndex] = newProject
        } else {
            projects.append(newProject)
            is_new = true
        }
        
        dbManager.saveValue(value: projects as AnyObject, forKey: "LaraProjects")
        
        
        
        
    }
    
    
    
    private func clearForm(){
        nameTf.stringValue = ""
        lPathTf.stringValue = ""
        rPathTf.stringValue = ""
        typePf.selectItem(at: 0)
    }
    
    @IBAction func browseFile(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a local folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        //dialog.alow        = ["txt"];
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                lPathTf.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
}
