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
    var projectTypeSources = ["Laravel", "xCode", "Mean", "Wordpress", "Android", "C++"];
    
    @IBOutlet weak var projectsTable: NSTableView!
    @IBOutlet weak var nameTf: NSTextField!
    @IBOutlet weak var lPathTf: NSTextField!
    @IBOutlet weak var rPathTf: NSTextField!
    @IBOutlet weak var typePf: NSPopUpButton!
    @IBOutlet weak var newBtn: NSButton!
    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    
    @IBOutlet weak var toolsTab: NSTabView!
    
    // MARK: Laravel Actions
    
    @IBAction func refreshAndSeedDb(_ sender: NSButton) {
        execCommand(commando: "cd \(lPathTf.stringValue) && php artisan migrate:refresh && php artisan db:seed")
    }
    
    @IBAction func artisanServe(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        cmd.launchTerminalWith(command: "cd \(localPath) && php artisan serve")
    }
    
    @IBAction func artisanGulp(_ sender: NSButton) {
        execCommand(commando: "cd \(lPathTf.stringValue) && gulp")
    }
    
    @IBAction func artisanNewController(_ sender: NSButton) {
        
        let commando = "cd \(lPathTf.stringValue) && php artisan make:controller %s"
        let titleText = "php artisan make:controller"
        let infoText = "Please insert the name for new controller"
        exeCommandWithPrompt(command: commando,title: titleText, infoText: infoText)
    }
    
    @IBAction func artisanPassportInstall(_ sender: NSButton) {
        execCommand(commando: "cd \(lPathTf.stringValue) && php artisan passport:install")
    }
    
    // MARK: File system and editor
    
    @IBAction func atomAction(_ sender: NSButton) {
        let atomPath = cmd.whichPath(executable: "atom")
        if atomPath.characters.count>1 {
            execCommand(commando:"atom \(lPathTf.stringValue)")
        }
    }
    
    @IBAction func finderAction(_ sender: NSButton) {
        execCommand(commando:"cd \(lPathTf.stringValue) && open .")
    }
    
    @IBAction func openTerminalAction(_ sender: NSButton) {
        let localPath = lPathTf.stringValue
        if localPath.isEmpty {
            return
        }
        cmd.launchTerminalWith(command: "cd \(localPath)")
    }
    
    
    // MARK: xCode
    
    @IBAction func openXcode(_ sender: NSButton) {
        execCommand(commando: "cd \(lPathTf.stringValue) && [ -e ./*.xcworkspace ] && open ./*.xcworkspace || open ./*.xcodeproj")
    }
    
    @IBAction func podsInit(_ sender: NSButton) {
        execCommand(commando:"cd \(lPathTf.stringValue) && pod init")
    }
    
    @IBAction func podfileEdit(_ sender: NSButton) {
        execCommand(commando:"atom \(lPathTf.stringValue)/Podfile")
    }
    
    @IBAction func podInstall(_ sender: NSButton) {
        execCommand(commando:"cd \(lPathTf.stringValue) && pod install")
    }
    
    // MARK: Git
    
    @IBAction func gitCommitAction(_ sender: NSButton) {
        
        let commando = "cd \(lPathTf.stringValue) && git add . && git commit -m \"%s\" && git push"
        let titleText = "Git commit message"
        let infoText = "A message its necesary to commit and push changes"
        exeCommandWithPrompt(command: commando,title: titleText, infoText: infoText)
        
    }
    
    @IBAction func gitInit(_ sender: NSButton) {
        execCommand(commando:"cd \(lPathTf.stringValue) && git init")
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
        
        var is_new:Bool = false
        if (currProject>=0){
            projects[currProject] = newProject
        } else {
            projects.append(newProject)
            is_new = true
        }
        
        dbManager.saveValue(value: projects as AnyObject, forKey: "LaraProjects")
        projectsTable.reloadData()
        
        if (is_new){
            newNotif(msg: "Project created succesfully.")
            currProject = projects.count-1
            projectsTable.selectRowIndexes([currProject], byExtendingSelection: false)
            selectProject(projecto: projects[currProject])
        } else {
            newNotif(msg: "Project saved succesfully.")
            projectsTable.selectRowIndexes([currProject], byExtendingSelection: false)
            selectProject(projecto: projects[currProject])
        }
        

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
    
    // MARK: Repeated Functions
    
    private func exeCommandWithPrompt(command:String, title: String, infoText:String, acceptText: String = "Add", cancelText:String = "Cancel" ) {
        
        let prompt = NSTextField(frame: NSMakeRect(0,0,260,20))
        
        let alert = NSAlert()
        alert.messageText = title
        alert.accessoryView = prompt
        alert.addButton(withTitle: acceptText)
        alert.addButton(withTitle: cancelText)
        alert.informativeText = infoText
     
        alert.beginSheetModal(for: self.view.window!, completionHandler: { [unowned self]  (returnCode) -> Void in
            if returnCode == NSAlertFirstButtonReturn {
                if !prompt.stringValue.isEmpty{
                    let commandfinal = command.replacingOccurrences(of: "%s", with: prompt.stringValue)
                    self.execCommand(commando: commandfinal)
                }
                
            }
        })
    }
    
    private func runFunction(action:String, param: String){
        
    }
    
    let notification = NSUserNotification.init()
    private func newNotif(msg:String, title:String = App.name.rawValue){
        
        print(msg)
        
        notification.title = title
        notification.informativeText = msg
        // put the path to the created text file in the userInfo dictionary of the notification
        //notification.userInfo = ["path" : fileName]
        // use the default sound for a notification
        notification.soundName = NSUserNotificationDefaultSoundName
        // if the user chooses to display the notification as an alert, give it an action button called "View"
        //notification.hasActionButton = true
        //notification.actionButtonTitle = "View"
        // Deliver the notification through the User Notification Center
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    private func execCommand(commando:String){
        let localPath = lPathTf.stringValue
        if localPath.isEmpty || commando.isEmpty {
            return
        }
        let output = commando.runAsCommand()
        newNotif(msg: output, title: nameTf.stringValue)
    }
    
    func selectProject(projecto: Dictionary<String, String>){
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
            if tbId == "git" || tbId  == "atom" {
                return true
            }
            if curProjectType == "xCode", tbId  == "xcode" {
                return true
            } else if curProjectType == "Laravel", tbId  == "lara" {
                return true
            } else if curProjectType == "Wordpress", tbId  == "wp" {
                return true
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
        selectProject(projecto: projects[row])
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

