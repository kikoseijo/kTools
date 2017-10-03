//
//  ViewController.swift
//  kTools
//
//  Created by sMac on 15/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Cocoa

//@IBDesignable

class HomebrewController: NSViewController {
    
    
    private let brew = Brew()
    private let cmd = Commander()
    
    var brewServices = [String : Bool]()
    var servicesArray = [String]()
    private var phpVersions = ["php55", "php56", "php70", "php71"]
    
    
    @IBOutlet var outputTextView: NSTextView!
    @IBOutlet weak var brewServicesPopUp: NSPopUpButton!
    @IBOutlet weak var brewStatusBtn: NSButton!
    @IBOutlet weak var brewStatusImg: NSImageView!
    @IBOutlet weak var servicesTableView: NSTableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        outputTextView.insertionPointColor = NSColor.white
        outputTextView.textColor = NSColor.white
        outputTextView.textStorage?.foregroundColor = NSColor.black
        
        loadBrewServices()
        
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        
        

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func updateBrewServiceImageStatus(status:String){
        let color = brewServices[status]! ? NSColor.green : NSColor.red
        brewStatusImg.image = tintedImage(NSImage(named: NSImage.Name(rawValue: "btn-power.png"))!, tint: color)
        servicesTableView.reloadData()
    }
    
    private func loadBrewServices()
    {
        
        
        servicesArray.removeAll()
        
        let servicesOutput = brew.getIsntalledServices()
        servicesArray = servicesOutput.servicesArray
        brewServices = servicesOutput.brewServices
 
        
        brewServicesPopUp.removeAllItems()
        brewServicesPopUp.addItems(withTitles: servicesArray)
        
        
        outputTextView.append(string: "$ sudo brew services list\n" + servicesOutput.output)
        
        if let thisService = brewServicesPopUp.selectedItem?.title {
            updateBrewServiceImageStatus(status: thisService)
        }
        
        
    }
    
    @IBAction func reloadBrewService(_ sender: NSButton) {
        loadBrewServices()
    }
    
    @IBAction func brewServiceChanged(_ sender: NSPopUpButton) {
        updateBrewServiceImageStatus(status: (sender.selectedItem?.title)!)
        
    }
    
    @IBAction func runBrewService(_ sender: NSButton)
    {
        let action = sender.tag == 1 ? "start" : "stop"
        let service = brewServicesPopUp.selectedItem?.title
        let command = "/usr/local/bin/brew services " + action + " " + service!
        cmd.runAndPrint(comandToRun: command, textView: outputTextView)
        brewServices[service!] = !brewServices[service!]!
        updateBrewServiceImageStatus(status: service!)
        
    }
    
    @IBOutlet weak var reloadService: NSButton!
    
    @IBAction func reloadServiceAction(_ sender: NSButton) {
        let service = brewServicesPopUp.selectedItem?.title
        let command = "/usr/local/bin/brew services reload " + service!
        cmd.runAndPrint(comandToRun: command, textView: outputTextView)
    }
    
  
}

extension HomebrewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return servicesArray.count 
    }
    
}

extension HomebrewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let StatusCell = "StatusCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // 1
        let serviceItem = servicesArray[row]
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = serviceItem
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = brewServices[serviceItem]==true ? "Started" : "Stopped"
            cellIdentifier = CellIdentifiers.StatusCell
        }
        
        // 3
        if let cell = servicesTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            //cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
}
