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
    
    @IBOutlet weak var projectsTable: NSTableView!
    @IBOutlet weak var nameLb: NSTextField!
    @IBOutlet weak var lpathLb: NSTextField!
    @IBOutlet weak var rpathLb: NSTextField!
    @IBOutlet weak var typeLb: NSTextField!
    
    @IBOutlet weak var refreshSeedBtn: NSButton!
    
    @IBAction func refreshAndSeedDb(_ sender: NSButton) {
        
        let localPath = lpathLb.stringValue
        if localPath.isEmpty {
            return
        }
        
        let commando = "cd \(localPath) && php artisan migrate:refresh && php artisan db:seed"
        let output = commando.runAsCommand()
        
        print(output)
        
    }
    
    @IBAction func addProject(_ sender: NSButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTable.delegate = self
        projectsTable.dataSource = self
        
        refreshSeedBtn.isEnabled = false
        
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
        let projecto = projects[row]
        
        nameLb.stringValue = projecto["name"]!
        lpathLb.stringValue = projecto["localPath"]!
        rpathLb.stringValue = projecto["remotePath"]!
        typeLb.stringValue = projecto["type"]!
        
        refreshSeedBtn.isEnabled = true
        
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

