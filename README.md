# ![App Icon][appicon]  kTools - OSX Gui for developpers

###

A little GUI writen in swift 3.0 that helps developper in the everyday task. This tools aims to simplify little taks like starting and stoping services without the need of open the console and typing all the commands whe dont normaly remember.

Its on a very ***BETA stage***, anyone interested its wellcome to contribute in this project.

This will be everyday taks that needs to be done on a regular basis with every new project, and the intention its to build over the time.

![Brew screen capture][Brew-capture]

## Current task done so far

The app itself its a tab style application, with 2 views for now,

- Allows you to `Start` or `Stop` Homebrew installed services
- Has build in NSTextView  simulating a log console to output the commands executed.
- At init will enquire `brew` to get services installed parsing the response of `/usr/local/bin/brew services list` command and creating a NSTableView to list the services and informs about where its Stopped or Running.

## Future taks

### SSH
- Explore the `~/.ssh` directory to be able to `edit`, `copy` or export keys to servers or TextEditors like `atom`

### Home Brew
- Be able to install Homebrew if not installed.
- Search and install brew packages.

### Webserver Hostings
- Create and monitor servers & running services.
- Install Wordpress or Laravel with a single click in choosen Webserver (Using SSH keys without the need to login, and trough command line install packages on remote servers)



#
###
###
###


[appicon]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/icon32x32.png "App icon"
[Brew-capture]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/Brew-capture.png "Brew screen capture"
