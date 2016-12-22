//
//  Brew.swift
//  kTools
//
//  Created by Altra Corporación on 21/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Foundation


class Brew {
    
    private let brewExec = ExecPaths.brew.rawValue + " "
    
    
    public func isFormulaInstalled(formula:String) -> Bool {
        
        //brew list | grep formula
        let command = brewExec + "list | grep " + formula
        let out = command.runAsCommand()
        let lines = out.characters.split{ $0 == "\n"}.map(String.init)
        print(lines)
        return lines.contains(formula)
        
    }
    
    public func startService(formula:String) -> String {
        let command = brewExec + "services start " + formula
        return command.runAsCommand()
    }
    
    public func stopService(formula:String) -> String {
        let command = brewExec + "services stop " + formula
        return command.runAsCommand()
    }
    
    public func reloadService(formula:String) -> String {
        let command = brewExec + "services reload " + formula
        return command.runAsCommand()
    }
    
    public func getIsntalledServices() -> (brewServices:[String : Bool] , servicesArray:[String], output : String)
    {
        
        let command = brewExec + "services list"
        let out = command.runAsCommand()
        var arr = [String]()
        var dic = [String : Bool]()
        
        var t=0
        let lines = out.characters.split{ $0 == "\n"}.map(String.init)
        for line in lines {
            if t>0 {    //First line are headers.
                let services = line.characters.split{ $0 == " "}.map(String.init)
                arr.append(services[0])
                dic[services[0]] = services[1] == "stopped" ? false : true
                
            }
            t += 1
        }
        
        return (dic, arr, out)
        
    }
    
}
