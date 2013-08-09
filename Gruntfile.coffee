'use-strict'
# require all grunt packages

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
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

    coffee:
      app:
        options:
          sourceMap: true
        files: 
          'server/javascripts/app.js' : ['app/coffee/**/*.coffee']

    compass: # compiles scss
      app:
        options:
          debugInfo: true
          sassDir: 'app/scss'
          cssDir: 'server/stylesheets'
          imagesDir: 'app/images'
          fontsDir: 'app/fonts'
          specify: 'app/scss/main.scss'

    haml: 
      handlebars:
        files: grunt.file.expandMapping ['app/haml/**/*.haml'], 'server/handlebars'
          ext: '.html'
          rename: (dest, matchedSrcPath, options) ->
            dest + matchedSrcPath.replace('app/haml','')
      index:
        files:
          'server/index.html' : 'server/index.haml'

    handlebars:
      app:
        options:
          namespace: 'handlebars'
          processName: (filePath) ->
            filePath.replace /(server\/handlebars\/|\.html)/g, ''
        files : 
          'server/javascripts/handlebars-templates.js' : 'server/handlebars/**/*.html'

    clean: # empties directories
      server: 'server'
      dist: 'dist'

    connect: # web server
      app:
        options:
          port: 9000
          hostname: '0.0.0.0'
          base: 'server'

    open: # opens the page in your default browser
      app:
        path: 'http://0.0.0.0:9000'

    'string-replace' : 
      index: 
        options :
          replacements : [
            pattern : '{{body}}'
            replacement : "<%= grunt.file.read('static/body.haml') %>"
          ]
        files :
          'server/index.haml' : 'static/html.haml'



  grunt.registerTask 'prepare-server', ['clean:server', 'coffee', 'compass', 'haml', 'handlebars']
  # Call these tasks from the command line
  grunt.registerTask 'server', ['prepare-server', 'connect', 'open', 'watch']
  grunt.registerTask 'default', ['server']