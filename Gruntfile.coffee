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
      refresh:
        files: ['.tmp/index.html', '.tmp/javascripts', '.tmp/stylesheets']
        options:
          livereload: 35729

    coffee:
      app:
        options:
          sourceMap: true
        files: 
          '.tmp/javascripts/app.js' : ['app/coffee/**/*.coffee']

    compass:
      app:
        options:
          debugInfo: true
          sassDir: 'app/scss'
          cssDir: '.tmp/stylesheets'
          imagesDir: 'app/images'
          fontsDir: 'app/fonts'
          specify: 'app/scss/main.scss'

    haml:
      handlebars:
        files: grunt.file.expandMapping ['app/haml/**/*.haml'], '.tmp/handlebars'
          ext: '.html'
          rename: (dest, matchedSrcPath, options) ->
            dest + matchedSrcPath.replace('app/haml','')
      index:
        files:
          '.tmp/index.html' : 'static/index.haml'

    handlebars:
      app:
        options:
          namespace: 'handlebars'
          processName: (filePath) ->
            filePath.replace /(\.tmp\/handlebars\/|\.html)/g, ''
        files : 
          '.tmp/javascripts/handlebars-templates.js' : '.tmp/handlebars/**/*.html'

    clean:
      tmp: '.tmp'
      dist: 'dist'

    connect:
      app:
        options:
          port: 9000
          
          # change this to '0.0.0.0' to access the server from outside
          hostname: '0.0.0.0'
          base: '.tmp'

    open:
      app:
        path: 'http://0.0.0.0:9000'

  grunt.registerTask 'server', ['clean:tmp', 'coffee', 'compass', 'haml', 'handlebars', 'connect', 'open', 'watch']
  grunt.registerTask 'default', ['server']