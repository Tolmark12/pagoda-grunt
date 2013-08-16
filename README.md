Grunt template 
==============

Grunt template prepped for CoffeeScript, Haml, Scss, and Handlebars

Requirements
------------
* git
* Ruby, with the compass gem installed
* node.js and npm
* npm packages - bower, grunt, grunt-cli :
  ```sudo npm install -g bower grunt grunt-cli```

Setup
-----

* Clone it

    ```git clone git@github.com:blunckr/pagoda-grunt.git *repo-name*```
* Get in the directory

  ```cd *repo-name*```
* Install

  ```npm install```

  ```bower install```
* Make your own repo

  ```rm -rf .git``` 

  ```git init```
* Remove build from .gitignore

Usage
-----

* Development mode

  ```grunt``` OR ```grunt server```
  Add ```-f``` so it doesn't exit on compile errors

* Prepare for distribution

  ```grunt build```
* package vendor scripts

  ```grunt lib```

Structure
---------

* app - working area, all scripts and styles will be packaged up
* build - where concat-ed, compiled, uglified scripts and styles live
* server - where compiled assets go to be served up
* stage - haml and scripts that are only used in the development environment, script should be minimal
* vendor - 3rd party assets, should be able to get everything with bower

*note - most of these directories won't exists until you run grunt commands, because they are gitignored*