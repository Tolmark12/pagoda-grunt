'use-strict'
#utilties
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->
  # require all grunt packages
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
  appName = "pagoda"
  # --------------------------- #
  # ---------- WATCH ---------- #
  # --------------------------- #
  grunt.initConfig
    watch:
      coffee: 
        files: ['app/coffee/*.coffee']
        tasks: ['coffee']
      compass:
        files: ['app/scss/**/*.scss']
        tasks: ['compass']
      handlebars:
        files: ['app/haml/**/*.haml']
        tasks: ['haml:handlebars','handlebars']
      static:
        files: ['static/*.haml']
        tasks: ['haml:index']
      refresh: # refreshes the page
        files: ['server/index.html', 'server/javascripts/*.js', 'server/stylesheets/*.css']
        options:
          livereload: true

    # ------------------------- #
    # -------- COMPILE -------- #
    # ------------------------- #
    coffee: # coffee -> js
      app:
        options:
          sourceMap: true 
        files: 
          'server/javascripts/app.js' : ['app/coffee/**/*.coffee']

    compass: # scss -> css
      server:
        options:
          debugInfo: true # source map, doesn't work currently in chrome :(
          sassDir: 'app/scss'
          cssDir: 'server/stylesheets'
          imagesDir: 'app/images'
          fontsDir: 'app/fonts'
          specify: 'app/scss/main.scss' # import everything from here
      build: # don't include source map
        options:
          debugInfo: false
          sassDir: 'app/scss'
          cssDir: 'server/stylesheets'
          imagesDir: 'app/images'
          fontsDir: 'app/fonts'
          specify: 'app/scss/main.scss'


    haml: # haml -> html
      handlebars:
        files: grunt.file.expandMapping ['app/haml/**/*.haml'], 'server/handlebars'
          ext: '.html'
          rename: (dest, matchedSrcPath, options) ->
            dest + matchedSrcPath.replace('app/haml','')
      index:
        files:
          'server/index.html' : 'server/index.haml'

    handlebars: # html -> js template
      app:
        options:
          namespace: 'handlebars'
          processName: (filePath) ->
            filePath.replace /(server\/handlebars\/|\.html)/g, ''
        files : 
          'server/javascripts/handlebars-templates.js' : 'server/handlebars/**/*.html'

    'string-replace' : # pastes body into the rest of the page 
      index: 
        options :
          replacements : [
            pattern : '{{body}}'
            replacement : "<%= grunt.file.read('static/body.haml') %>"
          ]
        files :
          'server/index.haml' : 'static/html.haml'
    
    # ----------------------- #
    # -------- SERVER ------- #
    # ----------------------- #
    clean: # empties directories
      server: 'server'
      build: 'build'

    connect: # web server
      app:
        options:
          port: 9000
          hostname: '0.0.0.0'
          middleware: (connect) ->
            [
              mountFolder(connect, "server")
              mountFolder(connect, "vendor")        
            ]
        

    open: # opens the page in the browser
      app:
        path: 'http://0.0.0.0:9000'

    # -------------------------- #
    # ---------- BUILD --------- #
    # -------------------------- #
    uglify:
      build:
        files: [
          src : ['server/javascripts/app.js', 'server/javascripts/handlebars-templates.js']
          dest: "build/#{appName}.min.js"
        ]

    cssmin:
      build:
        files: [
          src : 'server/stylesheets/main.css'
          dest : "build/#{appName}.min.css"  
        ]

    useminPrepare : 
      html : 'server/index.html'
      options:
        dest: "build"

  # ----------------------- #
  # --------- TASKS ------- #
  # ----------------------- #
  grunt.registerTask 'compile-server', ['clean:server', 'coffee', 'compass:server', 'string-replace', 'haml', 'handlebars']
  grunt.registerTask 'compile-build',  ['clean:server', 'clean:build', 'coffee', 'compass:build', 'string-replace', 'haml', 'handlebars']
  grunt.registerTask 'compile-lib',    ['clean:server', 'string-replace', 'haml:index']

  # Call these tasks from the command line
  grunt.registerTask 'server', ['compile-server', 'connect', 'open', 'watch']
  grunt.registerTask 'build',  ['compile-build', 'uglify:build', 'cssmin']
  grunt.registerTask 'lib',    ['compile-lib', 'useminPrepare', 'concat', 'uglify']
  grunt.registerTask 'default', ['server']
  grunt.registerTask 'lib', ['useminPrepare', 'concat', 'uglify']