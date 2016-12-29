//
//  LaraController.swift
//  kTools
//
//  Created by sMac on 27/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class ProjectsController: NSViewController {
    
    private let cmd = Commander()
    
    let dbManager = PlistManager.sharedInstance
    var projects: Array<Dictionary<String, String>> = []
    var currProject: Int = -1
    var projectTypeSources = ["Laravel", "xCode", "Mean", "Wordpress", "Android"];
    
    @IBOutlet weak var projectsTable: NSTableView!
    @IBOutlet weak var nameTf: NSTextField!
    @IBOutlet weak var lPathTf: NSTextField!
    @IBOutlet weak var rPathTf: NSTextField!
    @IBOutlet weak var typePf: NSPopUpButton!
    @IBOutlet weak var newBtn: NSButton!
    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    @IBOutlet weak var gitMsgTf: NSTextField!
    
    @IBOutlet weak var toolsTab: NSTabView!
    
    // MARK: Laravel Actions
    
    @IBAction func refreshAndSeedDb(_ sender: NSButton) {
        
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && php artisan migrate:refresh && php artisan db:seed"
        let output = commando.runAsCommand()
        
        print(output)
        
    }
    
    @IBAction func artisanServe(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        cmd.launchTerminalWith(command: "cd \(localPath) && php artisan serve")
    }
    
    @IBAction func artisanGulp(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && gulp"
        let output = commando.runAsCommand()
        
        print(output)
        
    }
    
    // MARK: File system and editor
    
    @IBAction func atomAction(_ sender: NSButton) {
        
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let atomPath = cmd.whichPath(executable: "atom")
        if atomPath.characters.count>1 {
            let command = "atom \(localPath)/"
            let res = command.runAsCommand()
            print(res)
        }
        
       
        
    }
    
    @IBAction func finderAction(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && open ."
        let output = commando.runAsCommand()
        
        print(output)
    }
    
    // MARK: xCode
    
    @IBAction func openXcode(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && [ -e ./*.xcworkspace ] && open \(localPath)/*.xcworkspace || open \(localPath)/*.xcodeproj"
        print(commando)
        let output = commando.runAsCommand()
        
        print(output)
    }
    
    
    // MARK: Git
    
    @IBAction func gitCommitAction(_ sender: NSButton) {
        let commitMesg = gitMsgTf.stringValue
        let localPath = lPathTf.stringValue
        if commitMesg.isEmpty, localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && git add . && git commit -m \"\(commitMesg)\" && git push"
        let output = commando.runAsCommand()
        print(output)
        
        gitMsgTf.stringValue = ""
        
        
    }
    
    // MARK: Projects CRUD
    
    @IBAction func newProject(_ sender: NSButton) {
        clearForm()
        currProject = -1
        saveBtn.isHidden = false
        newBtn.isHidden = true
        deleteBtn.isHidden = true
        
    }
    
    @IBAction func saveProject(_ sender: NSButton) {
        
        let tipo = typePf.selectedItem?.title
        
        let newProject: [String:String] = [
            "name" : nameTf.stringValue,
            "type" : tipo!,
            "localPath" : lPathTf.stringValue,
            "remotePath" : rPathTf.stringValue,
            ]
        if (currProject>=0){
            projects[currProject] = newProject
        } else {
            projects.append(newProject)
        }
        
        dbManager.saveValue(value: projects as AnyObject, forKey: "LaraProjects")
        projectsTable.reloadData()
        
        clearForm()
        
        saveBtn.isHidden = true
        newBtn.isHidden = false
        deleteBtn.isHidden = true
        
        
        
    }
    
    @IBAction func deleteProject(_ sender: NSButton) {
        projects.remove(at: currProject)
        dbManager.saveValue(value: projects as AnyObject, forKey: "LaraProjects")
        projectsTable.reloadData()
        currProject -= 1
        if currProject<0 {
            currProject = 0
        }
        if projects.count>0 {
            let index : IndexSet = [currProject]
            projectsTable.selectRowIndexes(index, byExtendingSelection: false)
        }
        
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
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectsTable.delegate = self
        projectsTable.dataSource = self
        
        typePf.addItems(withTitles: projectTypeSources)
        
        saveBtn.isHidden = false
        deleteBtn.isHidden = true
        newBtn.isHidden = true
        
        
        toolsTab.isHidden = true
        toolsTab.delegate = self
        
    }
    
    override func viewWillAppear() {
        
        projects = dbManager.getValueForKey(key: "LaraProjects") as! Array<Dictionary<String, String>>
        projectsTable.reloadData()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ProjectsController: NSTabViewDelegate {

    func tabView(_ tabView: NSTabView, shouldSelect tabViewItem: NSTabViewItem?) -> Bool{
        
        if(currProject>=0){
            let curProjectType = projects[currProject]["type"]
            let tbId = tabViewItem?.identifier as! String
            if curProjectType == "xCode" {
                if tbId  == "xcode" || tbId == "git" || tbId  == "atom"{
                    return true
                } else {
                    return false
                }
            } else if curProjectType == "Laravel" {
                if  tbId  == "lara" || tbId == "git" || tbId == "atom"{
                    return true
                } else {
                    return false
                }
            } else if curProjectType == "Wordpress" {
                if  tbId  == "wp" || tbId == "git" || tbId == "atom"{
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
}

extension ProjectsController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return projects.count
    }
    
}

extension ProjectsController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let LPathCell = "LPathCellID"
        static let RPathCell = "RPathCellID"
        static let TypeCell = "TypeCellID"
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        currProject = row
        let projecto = projects[row]
        
        nameTf.stringValue = projecto["name"]!
        lPathTf.stringValue = projecto["localPath"]!
        rPathTf.stringValue = projecto["remotePath"]!
        typePf.selectItem(withTitle: projecto["type"]!)
        
        toolsTab.isHidden = false
        if projecto["type"] == "Laravel" {
            toolsTab.selectTabViewItem(withIdentifier: "lara")
        } else if projecto["type"] == "xCode"{
            toolsTab.selectTabViewItem(withIdentifier: "xcode")
        } else if projecto["type"] == "wp"{
            toolsTab.selectTabViewItem(withIdentifier: "xcode")
        }
        
        saveBtn.isHidden = false
        newBtn.isHidden = false
        deleteBtn.isHidden = false
        
        return true
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // 1
        let project = projects[row]
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = project["name"]!
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = project["localPath"]!
            cellIdentifier = CellIdentifiers.LPathCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = project["remotePath"]!
            cellIdentifier = CellIdentifiers.RPathCell
        } else if tableColumn == tableView.tableColumns[3] {
            text = project["type"]!
            cellIdentifier = CellIdentifiers.TypeCell
        }
        
        // 3
        if let cell = projectsTable.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            //cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
    
    
}

