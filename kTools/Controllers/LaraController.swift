//
//  LaraController.swift
//  kTools
//
//  Created by sMac on 27/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class LaraController: NSViewController {
    
    let dbManager = PlistManager.sharedInstance
    var projects: Array<Dictionary<String, String>> = []
    var currProject: Int = -1
    
    @IBOutlet weak var projectsTable: NSTableView!
    @IBOutlet weak var nameTf: NSTextField!
    @IBOutlet weak var lPathTf: NSTextField!
    @IBOutlet weak var rPathTf: NSTextField!
    @IBOutlet weak var typePf: NSPopUpButton!
    @IBOutlet weak var newBtn: NSButton!
    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    @IBOutlet weak var gitMsgTf: NSTextField!

    
    @IBOutlet weak var refreshSeedBtn: NSButton!
    @IBOutlet weak var atomBtn: NSButton!
    @IBOutlet weak var gitCommitBtn: NSButton!
    
    @IBAction func refreshAndSeedDb(_ sender: NSButton) {
        
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && php artisan migrate:refresh && php artisan db:seed"
        let output = commando.runAsCommand()
        
        print(output)
        
    }
    
    @IBAction func atomAction(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        let commando = "/usr/local/bin/atom \(localPath)"
        let output = commando.runAsCommand()
        
        print(output)
        
    }
    @IBAction func gitCommitAction(_ sender: NSButton) {
        let commitMesg = gitMsgTf.stringValue
        let localPath = lPathTf.stringValue
        if commitMesg.isEmpty, localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && git add . && git commit -m \"\(commitMesg)\" && git push"
        let output = commando.runAsCommand()
        print(output)
    }
    
    @IBAction func addProject(_ sender: NSButton) {
        newProject(sender)
    }
    
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
            projects.insert(newProject, at: currProject)
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
        typePf.stringValue = ""
        
        refreshSeedBtn.isEnabled = true
        atomBtn.isEnabled = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTable.delegate = self
        projectsTable.dataSource = self
        
        refreshSeedBtn.isEnabled = false
        atomBtn.isEnabled = false
        saveBtn.isHidden = true
        deleteBtn.isHidden = true
        
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

extension LaraController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return projects.count
    }
    
}

extension LaraController: NSTableViewDelegate {
    
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
        typePf.stringValue = projecto["type"]!
        
        refreshSeedBtn.isEnabled = true
        atomBtn.isEnabled = true
        
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

