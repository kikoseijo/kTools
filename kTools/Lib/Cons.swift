//
//  Cons.swift
//  kTools
//
//  Created by Altra Corporación on 22/12/2016.
//  Copyright © 2016 Sunnyface.com. All rights reserved.
//

import Foundation

enum App:String {
    case name = "kTools"
    case version = "0.0.2"
}

enum ExecPaths: String {
    case brew = "/usr/local/bin/brew"
    case nginx = "/usr/local/bin/nginx"
    case atom = "/usr/local/bin/atom"
    case c = "C"
}

enum LaraProjects {
    case name
    case lPath
    case rPath
    case type
}



/*
 
 'php71' => '/usr/local/etc/php/7.1/php-fpm.d/www.conf',
 'php70' => '/usr/local/etc/php/7.0/php-fpm.d/www.conf',
 'php56' => '/usr/local/etc/php/5.6/php-fpm.conf',
 'php55' => '/usr/local/etc/php/5.5/php-fpm.conf',
 
 */
