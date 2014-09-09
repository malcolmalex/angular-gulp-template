# Angular-Gulp Project Template
gulp = require 'gulp'

# TODO: Maybe add npmlog for a debug-level of logging to look at file globs

# Plugins used in processing files
coffeelint        = require 'gulp-coffeelint'
coffeeCompile     = require 'gulp-coffee'
lesslint          = require 'gulp-recess'
less              = require 'gulp-less'
concat            = require 'gulp-concat'
sourcemaps        = require 'gulp-sourcemaps'
rename            = require 'gulp-rename'
templateCache     = require 'gulp-angular-templatecache'
ngmin             = require 'gulp-ng-annotate'
imagemin          = require 'gulp-imagemin'
minifyJS          = require 'gulp-uglify'
minifyCSS         = require 'gulp-minify-css'
jshint            = require 'gulp-jshint'
refresh           = require 'gulp-livereload'

# Utility plugins
del       = require 'del'
cache     = require 'gulp-cached'
remember  = require 'gulp-remember'
size      = require 'gulp-filesize'
flatten   = require 'gulp-flatten'
shell     = require 'gulp-shell'

# Config files for stubbing, path globs, error handling
server        = require './config/server'
paths         = require './config/paths'
errorHandler  = require './config/errors'

# Tasks

# Delete folders like dist, build, doc
# Callback ensures this completes before additional tasks in a dependency list
gulp.task 'clean', (cb) ->
  del paths.temp, {force: true}, cb

# Coffeelint app files that have changed; compile, doc, ngmin, concat all.
gulp.task 'coffee', ->
  gulp.src paths.app.coffee
    .pipe cache 'coffee-cache'
    .pipe coffeelint './config/coffeelint.json'
      .on 'error', errorHandler.onWarning
    .pipe coffeelint.reporter('default')
    .pipe remember 'coffee-cache'
    .pipe coffeeCompile {bare: true}
      .on 'error', errorHandler.onError
    .pipe ngmin()
    .pipe concat 'app.coffee.js'
    .pipe gulp.dest paths.build.scripts

# lint app javascript files that have changed; ngmin, concat all.
gulp.task 'js', ->
  gulp.src paths.app.scripts
    .pipe jshint()
      .on 'error', errorHandler.onWarning
    .pipe jshint.reporter('default')
    .pipe ngmin()
    .pipe concat 'app.scripts.js'
    .pipe gulp.dest paths.build.scripts    

# Lint and compile Less files.
# TODO: Convert to gulp-less-sourcemap.
# TODO: Just lint my less files, not vendor files
# FIXME: lint fails here with an error ... why? Result is nothing else runs
gulp.task 'less', ->
  gulp.src paths.app.stylesheets
    #.pipe lesslint()
    .pipe less()
      .on 'error', errorHandler.onWarning
    .pipe rename 'app.less.css'
    .pipe gulp.dest paths.build.stylesheets
    .pipe size()

# Concatenate vendor files with application files, create sourcemap
gulp.task 'concat:js', ['coffee'], ->
  gulp.src paths.vendor.scripts.concat [paths.build.scripts + "/app.coffee.js", paths.build.scripts + "/app.scripts.js"]
    .pipe sourcemaps.init()
      .pipe concat 'app.js'
    .pipe sourcemaps.write()
    .pipe gulp.dest paths.build.scripts
    .pipe size()



# clear the cache
gulp.task 'clearCache', ->
  delete cache.caches['coffee-cache']

# Need to clear cache before calling 'coffee' task repeatedly (from gulp watch).
# This is due to caching: 
#  .pipe remember 'coffee-cache'   
# Gulp watch calls this multiple times in the same session and seems to try to compile already 
# compiled coffeescript files after the first time it's called. gulp-remember remembers 
# all files that have been passed through it; compiled .js files must be getting added to the cache
#
# To workaround in the watch case, we will first clear the cache in this task before calling 
# concat:js
gulp.task 'cleanConcat:js', ['clearCache', 'concat:js'], ->
  console.log 'cleared coffee cache'

# Concatenate css files (currently no good sourcemap option)
# Note: paths.vendor.stylesheets comes last in this case to workaround fact that
# I can't @import the css file for nvd3 into main.less where I want it (less
# (always puts imported css files at the beginning and that causes issues
# with graph styling).
gulp.task 'concat:css', ['less'], ->
  gulp.src [paths.build.stylesheets + "/app.less.css"].concat paths.vendor.stylesheets
    .pipe concat 'app.css'
    .pipe gulp.dest paths.build.stylesheets
    .pipe size()

# Template Cache
gulp.task 'templates', ->
  gulp.src paths.app.templates
    .pipe templateCache 'template-cache.js', { module: "SampleApp"}
    .pipe gulp.dest paths.build.scripts

# Copy extras, such as index.html, favicon, and images
gulp.task 'copy:build', ->
  gulp.src ['app/index.html', 'app/favicon.ico']
    .pipe gulp.dest paths.build.root
  gulp.src paths.vendor.fonts
    .pipe gulp.dest paths.build.fonts
  gulp.src paths.app.images
    .pipe flatten()
    .pipe gulp.dest paths.build.images
  #gulp.src paths.vendor.images
  #  .pipe gulp.dest paths.build.images

# TODO: finish copy:dist task
gulp.task 'copy:dist', ->
  console.log 'No copy:dist task yet'

# Minify js
gulp.task 'minify:js', ->
  gulp.src [paths.build.scripts + '/app.js', paths.build.scripts + '/template-cache.js']
    .pipe minifyJS()
    .pipe concat 'app.min.js'
    .pipe gulp.dest paths.dist.scripts
    .pipe size()

# Minify css
gulp.task 'minify:css', ->
  gulp.src paths.build.stylesheets + '/app.less.css'
    .pipe minifyCSS()
    .pipe rename 'app.min.css'
    .pipe gulp.dest paths.dist.stylesheets
    .pipe size()

# Minify images
gulp.task 'minify:images', ->
  gulp.src paths.app.images
    .pipe imagemin {optimizationLevel: 5}
    .pipe gulp.dest paths.dist.images
    .pipe size()

# Start the development server
gulp.task 'server', ->
  server.startExpress()

###
--------------------------------------------
  Test Tasks
--------------------------------------------
###

# Compile tests and deposit in the build/scripts directory as test.coffee.js
gulp.task 'test:coffee', ->
  gulp.src paths.tests
    .pipe cache 'coffee-cache-test'
    .pipe coffeelint './config/coffeelint.json'
    .pipe coffeelint.reporter('default')
    .pipe remember 'coffee-cache-test'
    .pipe coffeeCompile {bare: true}
      .on 'error', errorHandler.onError
    .pipe concat 'test.coffee.js'
    .pipe gulp.dest paths.build.scripts

# Concatenate everything needed for testing into test.js
# TODO: tried to include dependencies on concat:js, templates, test:coffee
# but somewhere pipe get's broken and this task doesn't finish.
# If run gulp, then on another invocation run this separately, things work?!
gulp.task 'concat:test', ['test:coffee'], ->
  allTestJS = [
    paths.build.scripts + '/app.js'
    paths.build.scripts + '/template-cache.js'
    'test-helpers/*.js'
    paths.build.scripts + '/test.coffee.js'
  ]
  gulp.src allTestJS
    .pipe concat 'test.js'
    .pipe gulp.dest paths.build.scripts

# This function is called whenever application files have changed; it notifies
# the livereload server to send notifications to refresh any browser pages
notifyLiveReload =  (event) ->
  console.log('File ' + event.path + ' was ' + event.type + ', reloading...');

  # We do not pass in an existing tiny-lr instance; we let gulp-livereload() 
  # just creates a new instance of tiny-lr (and uses default livereload port of 35729)
  gulp.src event.path, { read:false }
    .pipe(refresh());

# Run testem, understanding dependencies
# FIXME: This produces weird characters and locked terminal.
# Workaround: just run testem from command line after gulp test
# gulp.task 'test', ['concat:test'], shell.task 'testem'
# gulp.task 'test', ['build', 'concat:test']
gulp.task 'test', ['concat:test']

# Convenience tasks providing dependencies
gulp.task 'concat', ['concat:js', 'concat:css']
gulp.task 'minify', ['minify:js', 'minify:css', 'minify:images']

gulp.task 'default', ['build']
gulp.task 'build', ['coffee', 'js', 'less', 'concat', 'templates', 'copy:build']
gulp.task 'dist', ['build', 'minify', 'copy:dist']

gulp.task 'watch', () ->
  gulp.watch paths.app.coffee, ['cleanConcat:js']
  gulp.watch paths.app.scripts, ['cleanConcat:js']
  gulp.watch paths.app.stylesheets, ['concat:css']
  gulp.watch paths.app.templates, ['templates']
  gulp.watch paths.app.images, ['copy:build']
  gulp.watch 'app/index.html', ['copy:build']

  # For live reload, we will add a watch on all of the generated output files
  builtFiles = [
    paths.build.scripts + '/app.js'
    paths.build.scripts + '/template-cache.js'
    paths.build.stylesheets + '/app.css'
    paths.build.root + '/index.html'
    paths.build.root + '/test.html'
  ]
  gulp.watch builtFiles, notifyLiveReload
