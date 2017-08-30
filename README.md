# ![App Icon][appicon]  kTools - OSX Gui for developpers

###

A little GUI writen in swift 3.0 that helps developper in the everyday task. This tools aims to simplify little taks like starting and stoping services without the need of open the console and typing all the commands whe dont normaly remember.

Its on a very ***BETA stage***, anyone interested its wellcome to contribute in this project.

This will be everyday taks that needs to be done on a regular basis with every new project, and the intention its to build over the time.

## Current task done so far

The app itself its a tab style application, with the following tabs:

### Commnander

- Runs commands with or without `sudo`.
- Flush DNS Cache on Sierra.
- Opens known_host file with atom editor.
- Opens Hombrew `nginx.conf` file with atom editor.
- Has built in NSTextView  simulating a console log to output the commands response being executed.

![Commander Tab capture][Commander-tab]

### Homebrew Tab

- Search for brew installed services using the command `brew list services` it parses the response and loads a NSTableView with the installed services with its active status
- Allows you to `Start` or `Stop` Homebrew installed services
- Has built in NSTextView simulating a console log to output the commands response being executed.

![Homebrew Tab capture][Homebrew-tab]

### Projects

The Projects Tab Interface is created to be able to interact with custom projects, its database its a `.plist` file created at `Library/Application Support/kTools` and allows creation of projects with: `name`, `localPath`, `remotePath` and `type`.

A basic ***CRUD*** has been added and you can `add`, `update` or `delete` projects using a GUI.

![Projects Tab capture][Projects-tab]

#### Finder && Text Editors

- Lets you open `atom` or `finder` in the ***localPath***.

#### Laravel

- Lets you open run `php artisan migrate:refresh` & `php artisan db:seed` on a single command.
- Can serve the project opening a Terminal Window and will run a `php artisan serve` on project´s folder.
- Can run `gulp` command on selected project

#### Git

- lets you `git add .` & `git commit -m 'CustomValue'` & `git push` on a single command.

#### xCode

- Opens xCode and will check for the existance of ***.xcworkspace*** and if false will open ***.xcodeproj***

## Up comming task

- Being able to select your prefered editor.


### Commander Tab
- Explore the `~/.ssh` directory to be able to `edit`, `copy` or export keys to servers or edit them with `atom`

### Homebrew Tab
- Be able to install Homebrew if not installed.
- Search and install brew packages.
- Search and install php versions.

### Server Monitor Tab
- Create and monitor servers & running services.
- Install Wordpress or Laravel with a single click in chosen Webserver (Using SSH keys without the need to login, and trough command line install packages on remote servers).
- Be able to distinguish Wordpress, Mean, Laravel Projects to fire selective actions.



#
###
###
###
 Made in Spain, with love, by ***Kiko Seijo***

#

[appicon]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/icon32x32.png "App icon"
[Homebrew-tab]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/Homebrew-Tab.png "Brew screen capture"
[Commander-tab]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/Commander-Tab.png "Brew screen capture"
[Projects-tab]: https://github.com/kikoseijo/kTools/raw/master/kTools/Images/Projects-Tab.png "Brew screen capture"
