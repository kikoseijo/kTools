//
//  Brew.swift
//  kTools
//
//  Created by Altra Corporación on 21/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Foundation


class Brew {
    
    private let brewPath = "/usr/local/bin/"
    
    
    public func installed(formula:String){
        
        //brew list | grep formula
        
    }
    
    public func getIsntalledServices() -> (brewServices:[String : Bool] , servicesArray:[String], output : String)
    {
        
        let command = brewPath + "brew services list"
        let out = command.runAsCommand()
        var arr = [String]()
        var dic = [String : Bool]()
        
        var t=0
        let lines = out.characters.split{ $0 == "\n"}.map(String.init)
        for line in lines {
            if t>0 {
                let services = line.characters.split{ $0 == " "}.map(String.init)
                arr.append(services[0])
                dic[services[0]] = services[1] == "stopped" ? false : true
                
            }
            t += 1
        }
        
        return (dic, arr, out)
        
    }
    
}
