//
//  ProjectsEditController.swift
//  kTools
//
//  Created by sMac on 08/01/2017.
//  Copyright © 2017 Sunnyface.com. All rights reserved.
//

import Cocoa

protocol ProjectsEditControllerDelegate: class {
    func closedView(controller: ProjectsEditController, beenChanged: Bool)
}

class ProjectsEditController: NSViewController {
    
    weak var delegate: ProjectsEditControllerDelegate?
    public var project:Project = Project()
    public var projectIndex: Int = -1
    
    private var projectTypeSources = ["Laravel", "xCode", "Mean", "Wordpress", "Android", "C++", "PHP"]
    private var repoStatus : String = "" {
        didSet {
            repoTypeGitBtn.state = repoStatus == "git" ? 1 : 0
            repoTypeNoneBtn.state = repoStatus == "none" ? 1 : 0
            repoTypeHgBtn.state = repoStatus == "hg" ? 1 : 0
        }
    }
    let dbManager = PlistManager.sharedInstance
    var projects: [Dictionary<String,String>] = []
    
    @IBOutlet weak var nameTf: NSTextField!
    @IBOutlet weak var lPathTf: NSTextField!
    @IBOutlet weak var rPathTf: NSTextField!
    @IBOutlet weak var lUrlTf: NSTextField!
    @IBOutlet weak var rUrlTf: NSTextField!
    
    @IBOutlet weak var typePf: NSPopUpButton!
    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet weak var repoTypeNoneBtn: NSButton!
    @IBOutlet weak var repoTypeGitBtn: NSButton!
    @IBOutlet weak var repoTypeHgBtn: NSButton!
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePf.addItems(withTitles: projectTypeSources)
        
        if project.name != "" {
            nameTf.stringValue = project.name
            lPathTf.stringValue = project.lPath
            rPathTf.stringValue = project.rPath
            typePf.selectItem(withTitle: project.type)
            lUrlTf.stringValue = project.lUrl
            rUrlTf.stringValue = project.rUrl
            repoStatus = project.gitCommand != "" ? project.gitCommand : "none"
        } else {
            repoStatus = "none"
        }
    }
    
    override func viewWillAppear() {
        
       projects = dbManager.getValueForKey(key: "LaraProjects") as! [Dictionary<String,String>]
        
    }
    
    @IBAction func saveProject(_ sender: NSButton) {
        
        let tipo = typePf.selectedItem?.title
        
        
        
        let newProject: [String:String] = [
            "name" : nameTf.stringValue,
            "type" : tipo!,
            "localPath" : lPathTf.stringValue,
            "remotePath" : rPathTf.stringValue,
            "rUrl" : rUrlTf.stringValue,
            "lUrl" : lUrlTf.stringValue,
            "gitCommand" : repoStatus
            ]
        
        if (projectIndex >= 0){
            projects[projectIndex] = newProject
        } else {
            projects.append(newProject)
        }
        
        
        dbManager.saveValue(value: projects as AnyObject, forKey: "LaraProjects")
        delegate?.closedView(controller: self, beenChanged:true)
        
        self.dismiss(self)
        
    }
    
    
    
    private func clearForm(){
        nameTf.stringValue = ""
        lPathTf.stringValue = ""
        rPathTf.stringValue = ""
        typePf.selectItem(at: 0)
    }
    
    
    @IBAction func repoTypeAction(_ sender: NSButton) {
        repoStatus = sender.identifier != "" ? sender.identifier! : "none"
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