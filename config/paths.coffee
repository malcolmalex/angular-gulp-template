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
  tests: "app/**/*_test.coffee"
  docs: 'docs'
  build:
    root: 'build'
    scripts: 'build/scripts'
    stylesheets: 'build/stylesheets'
    fonts: 'build/fonts'
    images: 'build/images'
  dist:
    scripts: 'dist/scripts'
    stylesheets: 'dist/stylesheets'
    fonts: 'dist/fonts'
    images: 'dist/images'

# Stuff it's ok to delete with the clean task
  temp: [
    'docs'
    'build'
    'dist'
  ]