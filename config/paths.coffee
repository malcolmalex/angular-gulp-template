# Path globs
module.exports =
  app:
    coffee: [      
      "app/app.coffee"
      "app/**/*controller.coffee"
      "app/**/*directive.coffee"
      "app/**/*filter.coffee"  
      "app/**/*service.coffee"
    ]
    scripts:  [ "app/app.js"
      "app/**/*controller.js"
      "app/**/*directive.js"
      "app/**/*filter.js"  
      "app/**/*service.js"
    ]
    stylesheets: "app/stylesheets/main.less"
    templates: "app/components/**/*.html"
    images: [
      "app/**/images/*.*"
    ]
  vendor:
    scripts: [
      "vendor/bower/lodash/dist/lodash.js"
      "vendor/bower/angular/angular.js"
      "vendor/bower/angular-ui-router/release/angular-ui-router.js"
      "vendor/bower/angular-bootstrap/ui-bootstrap-tpls.js"
      "vendor/bower/angular-cookies/angular-cookies.js"
      "vendor/bower/angular-resource/angular-resource.js"
      "vendor/bower/angular-sanitize/angular-sanitize.js"
      "vendor/bower/restangular/dist/restangular.js"
      "vendor/bower/angular-translate/angular-translate.js"
      "vendor/bower/d3/d3.js"
      "vendor/bower/nvd3/nv.d3.js"
      "vendor/bower/angularjs-nvd3-directives/dist/angularjs-nvd3-directives.js"
      "vendor/js/**/*.js"
    ]
    stylesheets: [
      "vendor/bower/nvd3/nv.d3.css"
    ]
    images: []
    fonts: 'vendor/bower/bootstrap/fonts/*'
  tests: [
    "app/**/*_test.coffee"
    "app/**/*_test.js"
  ]
  docs: 'docs'

  # The build and dist are located outside the project directory.  See Issue
  # https://github.com/malcolmalex/angular-gulp-template/issues/1
  # TODO: Build these other globs from the root
  build:
    root: '../agt-build'
    scripts: '../agt-build/scripts'
    stylesheets: '../agt-build/stylesheets'
    fonts: '../agt-build/fonts'
    images: '../agt-build/images'
  dist:
    root: '../agt-dist'
    scripts: '../agt-dist/scripts'
    stylesheets: '../agt-dist/stylesheets'
    fonts: '../agt-dist/fonts'
    images: '../agt-dist/images'

  # Stuff it's ok to delete with the clean task
  # TODO: reference the build and dist as defined above
  temp: [
    'docs'
    '../agt-build'
    '../agt-dist'
  ]
