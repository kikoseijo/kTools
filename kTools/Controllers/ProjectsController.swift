//
//  ProjectsController.swift
//  kTools
//
//  Created by sMac on 27/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class ProjectsController: NSViewController, ProjectsEditControllerDelegate {
    
    private let cmd = Commander()
    
    let dbManager = PlistManager.sharedInstance
    var projects: [Project] = []
    var curIndex: Int = -1
    var curProject : Project = Project() {
        didSet{
            lPathLb.stringValue = curProject.lPath
            rPathLb.stringValue = curProject.rPath
            projectNameLb.stringValue = curProject.name
            if curProject.lUrl != "" {
                lUrlBtn.isHidden = false
                lUrlBtn.title = curProject.lUrl
            } else {
                lUrlBtn.isHidden = true
            }
            if curProject.rUrl != "" {
                rUrlBtn.isHidden = false
                rUrlBtn.title = curProject.rUrl
            } else {
                rUrlBtn.isHidden = true
            }
        }
    }
    var projectArrayController:NSArrayController = NSArrayController()
    
    @IBOutlet weak var projectsTable: NSTableView!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var newBtn: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var lUrlBtn: NSButton!
    @IBOutlet weak var rUrlBtn: NSButton!
    @IBOutlet weak var projectNameLb: NSTextField!
    @IBOutlet weak var lPathLb: NSTextField!
    @IBOutlet weak var rPathLb: NSTextField!
    
    
    // MARK: Laravel Actions
    
    @IBAction func refreshAndSeedDb(_ sender: NSButton) {
        execCommand(commando: "cd \"\(curProject.lPath)\" && php artisan migrate:refresh && php artisan db:seed")
    }
    
    @IBAction func artisanServe(_ sender: NSButton) {
        let localPath = curProject.lPath
        if localPath.isEmpty {
            return
        }
        cmd.launchTerminalWith(command: "cd \"\(curProject.lPath)\" && php artisan serve")
    }
    
    @IBAction func artisanGulp(_ sender: NSButton) {
        execCommand(commando: "cd \(curProject.lPath) && gulp")
    }
    
    
    @IBAction func artisanPassportInstall(_ sender: NSButton) {
        execCommand(commando: "cd \(curProject.lPath) && php artisan passport:install")
    }
    
    // MARK: File system and editor
    
    @IBAction func atomAction(_ sender: NSButton) {
        let atomPath = cmd.whichPath(executable: "atom")
        if atomPath.characters.count>1 {
            execCommand(commando:"atom \"\(curProject.lPath)\"")
        }
    }
    
    @IBAction func finderAction(_ sender: NSButton) {
        execCommand(commando:"cd \"\(curProject.lPath)\" && open .")
    }
    
    @IBAction func openTerminalAction(_ sender: NSButton) {
        let localPath = curProject.lPath
        if localPath.isEmpty {
            return
        }
        cmd.launchTerminalWith(command: "cd \(localPath)")
    }
    
    
    // MARK: xCode
    
    @IBAction func openXcode(_ sender: NSButton) {
        execCommand(commando: "cd \"\(curProject.lPath)\" && [ -e ./*.xcworkspace ] && open ./*.xcworkspace || open ./*.xcodeproj", output: "Openning xCode App")
    }
    
    @IBAction func podsInit(_ sender: NSButton) {
        execCommand(commando:"cd \"\(curProject.lPath)\" && pod init")
    }
    
    @IBAction func podfileEdit(_ sender: NSButton) {
        execCommand(commando:"atom \"\(curProject.lPath)/Podfile\"")
    }
    
    @IBAction func podInstall(_ sender: NSButton) {
        execCommand(commando:"cd \"\(curProject.lPath)\" && pod install")
    }
    
    // MARK: Git
    
    @IBAction func gitCommitAction(_ sender: NSButton) {
        
        if curProject.gitCommand == "git" || curProject.gitCommand == "hg" {
            let commando = "cd \"\(curProject.lPath)\" && \(curProject.gitCommand) add . && \(curProject.gitCommand) commit -m \"%s\" && \(curProject.gitCommand) push"
            let titleText = "Git commit message"
            let infoText = "A message its necesary to commit and push changes"
            exeCommandWithPrompt(command: commando,title: titleText, infoText: infoText)
        }
        
        
        
    }
    
    @IBAction func gitInit(_ sender: NSButton) {
        execCommand(commando:"cd \"\(curProject.lPath)\" && git init")
    }
    
    
    // MARK: Projects CRUD
    
    @IBAction func deleteProject(_ sender: NSButton) {
        
        let a = NSAlert()

        a.messageText = "Delete the project?"
        a.informativeText = "Are you sure you would like to delete the project permanently?\n\nAttention: This cant be undone!"
        a.addButton(withTitle: "Delete")
        a.addButton(withTitle: "Cancel")
        a.alertStyle = .warning
        
        a.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                print("Project deleted succesfully")
                self.deleteCurrentSelectedProject()
            } else {
                print("Delete canceled")
            }
        })
        
        
        
    }
    
    private func deleteCurrentSelectedProject(){
        
        let toDeleteProject = curProject.name
        let deleteIndex = projects.index(of: curProject)
        if deleteIndex! < projects.count, deleteIndex! >= 0 {
            
            projects.remove(at: deleteIndex!)
            projectArrayController.content = nil
            projectArrayController.content = projects
            let newArrayProjects:NSMutableArray = []
            for project in projects {
                let aProject = project.toDictionary()
                newArrayProjects.add(aProject)
            }
            dbManager.saveValue(value: newArrayProjects as AnyObject, forKey: "LaraProjects")
            projectsTable.reloadData()
            newNotif(msg: "Project deleted succesfully", title: toDeleteProject)
            if projects.count>0 {
                let index : IndexSet = [curIndex]
                projectsTable.selectRowIndexes(index, byExtendingSelection: false)
            }
        }
        
        
    }
    
    @IBAction func newProject(_ sender: NSButton) {
        let projectEditVC = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "editProjectSheet")) as! ProjectsEditController
        projectEditVC.delegate = self
        self.presentViewControllerAsSheet(projectEditVC)
    }
    
    @IBAction func editProject(_ sender: NSButton) {
        let projectEditVC = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "editProjectSheet")) as! ProjectsEditController
        projectEditVC.project = curProject
        projectEditVC.projectIndex = projects.index(of: curProject)!
        projectEditVC.delegate = self
        self.presentViewControllerAsSheet(projectEditVC)
    }
    
    func closedView(controller: ProjectsEditController, beenChanged: Bool) {
        if beenChanged {
            print("Delegated called, beenChanged: \(beenChanged)")
            reloadDbData()
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
            if returnCode == NSApplication.ModalResponse.alertFirstButtonReturn {
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
        //notification.soundName = NSUserNotificationDefaultSoundName
        // if the user chooses to display the notification as an alert, give it an action button called "View"
        //notification.hasActionButton = true
        //notification.actionButtonTitle = "View"
        // Deliver the notification through the User Notification Center
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    private func execCommand(commando:String, output:String = ""){
        let localPath = curProject.lPath
        if localPath.isEmpty || commando.isEmpty {
            return
        }
        let resOutput =  commando.runAsCommand()
        let finalOutput =  output.characters.count>0 ? output : resOutput
        newNotif(msg: finalOutput, title: curProject.name)
    }
    
    @objc func projectSearchAction(searchString: NSString){
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ or type CONTAINS[cd] %@", searchString, searchString)
        if searchString != "" {
            projectArrayController.filterPredicate = predicate
        } else {
            projectArrayController.filterPredicate = nil
        }
        projectsTable.reloadData()
    }
    
    func selectProjectTab(){
//        toolsTab.isHidden = false
//        if curProject.type == "Laravel" {
//            toolsTab.selectTabViewItem(withIdentifier: "atom")
//        } else if curProject.type == "xCode"{
//            toolsTab.selectTabViewItem(withIdentifier: "xcode")
//        } else if curProject.type == "wp"{
//            toolsTab.selectTabViewItem(withIdentifier: "xcode")
//        }
        deleteBtn.isEnabled = true
        editButton.isEnabled=true
    }
    
    private func reloadDbData(){
        let projectsArray = dbManager.getValueForKey(key: "LaraProjects") as! Array<Dictionary<String, String>>
        projects.removeAll()
        for record in projectsArray {
            projects.append(Project.createProjectFrom(dicc: record))
        }
        projectArrayController.content = nil
        projectArrayController.content = projects
        projectsTable.reloadData()
    }
    
    @IBAction func openLocalUrl(_ sender: NSButton) {
        if curProject.lUrl != "" {
            openUrlOnBrowser(curProject.lUrl)
        }
    }
    
    @IBAction func openRemoteUrl(_ sender: NSButton) {
        if curProject.rUrl != "" {
            openUrlOnBrowser(curProject.rUrl)
        }
    }
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectsTable.delegate = self
        projectsTable.dataSource = self
        searchField.delegate = self
        searchField.action = #selector(projectSearchAction(searchString:))
        
        deleteBtn.isEnabled = false
        editButton.isEnabled = false
        lUrlBtn.isHidden = true
        rUrlBtn.isHidden = true
        projectNameLb.stringValue = "Active project"
        lPathLb.stringValue = "Select project from the table of add a new one."
        rPathLb.stringValue = ""

        
        // 1
        let descriptorName = NSSortDescriptor(key: "name", ascending: true)
        let descriptorType = NSSortDescriptor(key: "type", ascending: true)
        
        // 2
        projectsTable.tableColumns[0].sortDescriptorPrototype = descriptorName
        projectsTable.tableColumns[1].sortDescriptorPrototype = descriptorType
        
    }
    
    override func viewWillAppear() {
        NSLog("viewWillAppear()")
        
    }
    
    override func viewDidAppear() {

        NSLog("viewDidAppear()")
        reloadDbData()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
// MARK: NSSearchFieldDelegate
extension ProjectsController: NSSearchFieldDelegate{
    override func controlTextDidChange(_ obj: Notification) {
        NSLog("im searching.")
        var searchString = ""
        searchString = ((obj.object as? NSSearchField)?.stringValue)!
        projectSearchAction(searchString: searchString as NSString)
    }
}
// MARK: NSTabViewDelegate
extension ProjectsController: NSTabViewDelegate {

    func tabView(_ tabView: NSTabView, shouldSelect tabViewItem: NSTabViewItem?) -> Bool{
        
        if(curProject.name != ""){
            let tbId = tabViewItem?.identifier as! String
            if tbId == "git" || tbId  == "atom" {
                return true
            }
            if curProject.type == "xCode", tbId  == "xcode" {
                return true
            } else if curProject.type == "Laravel", tbId  == "lara" {
                return true
            } else if curProject.type == "Wordpress", tbId  == "wp" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
}
// MARK: NSTableViewDataSource
extension ProjectsController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (projectArrayController.arrangedObjects as! [Project]).count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        // 1
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        let sortedProjects = (projects as NSArray).sortedArray(using: [sortDescriptor])
        projectArrayController.content = nil
        projectArrayController.content = sortedProjects
        projectArrayController.rearrangeObjects()
        projectsTable.reloadData()
        
    }
}
// MARK: NSTableViewDelegate
extension ProjectsController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let TypeCell = "TypeCellID"
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        curIndex = row
        let theArray = projectArrayController.arrangedObjects as! [Project]
        curProject = theArray[curIndex]
        selectProjectTab()
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if projectsTable.selectedRow<0 {
            let index : IndexSet = [curIndex]
            projectsTable.selectRowIndexes(index, byExtendingSelection: false)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // 1
        let theArray = projectArrayController.arrangedObjects as! [Project]
        let project = theArray[row]
        //let project = projectArrayController.arrangedObjects[row] as Project
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = project.name
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = project.type
            cellIdentifier = CellIdentifiers.TypeCell
        }
        
        // 3
        if let cell = projectsTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            //cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
    
    
}

