angular-gulp-template
=====================

Angular-gulp-template is a [GulpJS](http://gulpjs.com)-based project template for [AngularJS](http://angularjs.org) projects.

It's inspired by the awesome [LinemanJS](http://linemanjs.com) and the [lineman-angular-template](https://github.com/linemanjs/lineman-angular-template), but instead of grunt, uses gulp's stream-processing
approach.  It started out as an experiment, and thought I'd share.

One important feature of this template is that it attempts to provide a flexible project
structure adhering to Google's recommendations (angular blog [here](http://blog.angularjs.org/2014/02/an-angularjs-style-guide-and-best.html),
recommendation [here](https://docs.google.com/document/d/1XXMvReO8-Awi1EZXAXS4PzDzdNvV6pGcuaF4Q9821Es/pub)) on
organizing larger projects into components. With this approach, components can be nested arbitrarily within a project,
and unit tests are located right near the code under test.  This doesn't attempt to follow the recommendation perfectly,
but does allow for a recursive hierarchy of components and pretty much follows the naming conventions.

The goal of this template is to provide simple examples of a few Angular capabilities you might want to use in
a larger application - all in one place, with the gulp-setup included.

# Features

- General Gulp processing
  - linting and compiling of coffeescript, javascript, less
  - sourcemap generation
- [Coffeescript](http://coffeescript.org/) or JavaScript for all scripting, including configuration and application. Note that most of the examples use coffeescript, but js works as well.
- Builds a sample AngularJS app with a few useful libraries and some helpful configuration
  - [AngularUI bootstrap](http://angular-ui.github.io/bootstrap/) ready to use
  - A basic responsive bootstrap setup
  - Simple routing example with [AngularUI UI-router](https://github.com/angular-ui/ui-router)
  - d3.js-based graph using nvd3, provided by [AngularJS-nvd3-directives](http://cmaurer.github.io/angularjs-nvd3-directives/)
  - [Restangular](https://github.com/mgonto/restangular) to simplify integration with REST apis
  - Automatic incorporation of all templates into the angular template cache
  - Angular pre-minification with [ngmin](https://github.com/btford/ngmin)
- Distribution tasks like image minification
- [Bootstrap 3](http://getbootstrap.com) + [LESS](http://lesscss.org) setup, leveraging mixins and variables to customize bootstrap
- [Bower](http://bower.io) for managing application dependencies
- [Jasmine](http://jasmine.github.io/) for unit tests, with @searls [jasmine-given](https://github.com/searls/jasmine-given) for given-when-then syntactic sugar
- [Testem](https://github.com/airportyh/testem) as the unit test runner
- [Protractor](https://github.com/angular/protractor) for E2E tests
- Beginnings of api-stubbing (a la lineman) with an included [expressjs](http://expressjs.com/) server
- Watch and live-reload for streamlined developer workflow

# Quickstart

1. `git clone git@github.com:malcolmalex/angular-gulp-template.git my-app`
2. `cd my-app`
3. `npm install`
4. `gulp`
5. `gulp server`

Open your web browser to localhost:4000.

> Note: after `gulp server`, run `gulp watch`, edit some files, and enjoy the benefits of a live-reload-based workflow.  Thanks to tommut for getting this working!

To run unit tests:

1. `gulp test`
2. `testem`

To run e2e tests, see E2E Testing section below (there are just a few config steps).

> Note: The watch tasks are not working yet, so a typical approach to the dev cycle is to `gulp` in one terminal window,
and run `gulp server` in another.

# Gulp setup

It's helpful to talk about the result of a build first.  `gulp build` or just `gulp` produces the following, which
then is served by express when you run `gulp server`:

```
build
├── favicon.ico
├── fonts
│   ├── glyphicons-halflings-regular.eot
│   ├── glyphicons-halflings-regular.svg
│   ├── glyphicons-halflings-regular.ttf
│   └── glyphicons-halflings-regular.woff
├── images
│   ├── AngularJS-large.png
│   └── gulp-2x.png
├── index.html
├── scripts
│   ├── app.coffee.js
│   ├── app.js
│   ├── app.js.map
│   └── template-cache.js
└── stylesheets
    ├── app.css
    └── app.less.css
```

There are a few intermediate files, but the main idea is that `scripts/app.js` contains all the
javascript for the application, `scripts/template-cache.js` contains the "partials" or templates,
and `stylesheets/app.css` contains all the style information.

This means that regardless of the libraries you add via bower, or the way you organize/nest your components within the
`app` directory, your final `index.html` only needs to include the following:

```html
  <link rel="stylesheet" type="text/css" href="/stylesheets/app.css" media="all" />
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
  <script type="text/javascript" src="/scripts/app.js"></script>
  <script type="text/javascript" src="/scripts/template-cache.js"></script>
```

> Note: you will have to update `config\paths.coffee` to ensure the appropriate files are included in the build
process.

# Project structure

Here is the directory structure - the gulp processing makes certain assumptions about how angular projects are organized
(though most of it is configurable):

```
├── app                       -- Angular content, including app.coffee, index.html (main page) and favicon files
│   ├── components            -- Any organization of .html templates, .coffee, .less and static resources
│   └── stylesheets           -- 3 .less files: main.less, mixins.less, variables.less
├── config                    -- Path globs, error handling, express config
├── data                      -- JSON files for use in stubbing REST apis, served by express
├── node_modules              -- local node modules for gulp use
├── test-e2e                  -- protractor test cases
├── test-helpers              -- any helper js that needs to be included
└── vendor
    ├── bower                 -- app dependencies managed by bower
    ├── fonts                 -- 3rd party fonts (from bootstrap in this case)
    ├── images                -- 3rd party images
    ├── scripts               -- 3rd party js
    └── stylesheets           -- 3rd party stylesheets
```

Then somewhere outside of this structure ...

```
├── agt-build                     -- Output of the build process, served by express
│   ├── fonts
│   ├── images
│   ├── scripts
│   └── stylesheets
```
> Note: This project template defaults to dropping this folder *outside* the project directory structure to better support a VM-type of dev environment arrangement where you want to minimize the project files that are sync'd between host and guest dev environment.  See [Issue #1](https://github.com/malcolmalex/angular-gulp-template/issues/1).
 

## Components

The application itself includes a couple of "components"; a sample component which in turn includes an accordian,
a chart, and a to-do form.  Rather than
organize an application into controllers, services, directives, etc., this template encourages the use of folders
to represent real application components.  Those folders can contain .coffee, .html, .less files as well as static
content like images.

Also, the default configuration allows you to embed unit tests right in the component directory rather than
storing them in a separate test directory.  As long as files are of the form `*_test.coffee`,
the build system knows what to do.  This is configurable - see the `config/paths.coffee` for all the globs
configured by default.

## Styles

The setup here uses three main less files to enable clean separation of customized stylesheets from the original sources.
While bootstrap encourages the generation of stylesheets with their website, for all but the most trivial appliations
this is going to make things difficult to maintain and evolved.  So this app does the following to simplify things:

- `app/stylesheets/main.less` explicitly controls stylesheet import order, and imports the source .less from bootstrap
- `app/stylesheets/mixins.less` is used for the project's mixins as needed
- `app/stylesheets/variables.less` provides all the variable overrides desired

## Configuration

The config directory contains a few files helpful for the setup of gulp. The most important of which is
`config/paths.coffee`.  A few helpful notes about this config file:

- This setup encourages you to name your angular files so it's clear what they are: `*controller.coffee`, for example.
- Unit tests are meant to be embedded right with the content under test, for maintainability.  Tests are named like `*_test.coffee`.
- Any .html file found under `app/components` is presumed to be a template file and is added to the template cache.
- Vendor javascript is explicitly listed to ensure the js appears in the resulting `app.js` in the correct order
- All stylesheets are imported from `app/stylesheets/main.less`

## Data

This just includes a few example json objects as examples of how you could stub an api with express. Drop a json
object here, and add it to the `setupProxyAPIs` function of `config/server.coffee`.  As an example, the
initial to-do list is provided in `data/todos.json`, served up on `http://localhost:4000/todos`, and read in todo component
by the todo-controller with the following statement:

```coffeescript
    $scope.todos = Restangular.all('todos').getList().$object
```

# Unit Testing

Unit tests are run with Testem, the setup is something like this:

```json
{
  "framework": "jasmine",
  "launch_in_dev": [
    "Chrome"
    ],
  "launch_in_ci" : ["PhantomJS"],
  "src_files": [
    "build/scripts/app.js",
    "build/scripts/test.js"
    ],
  "serve_files": "build/scripts/test.js"
}
```
1. `gulp build` (if necessary)
2. `gulp test` (to generate `build/scripts/test.js` file)
3. `testem` (will execute the test)

Basically, test.js ends up with everything needed for testem to run. Additional browsers can be added in the *"launch_in_dev"* element.  See the [Testem](https://github.com/airportyh/testem) documentation for more information.

# E2E Testing

This project template is configured to use [Protractor](https://github.com/angular/protractor) as the runner for E2E testing -
a framework designed with AngularJS in mind.  Jasmine, again, is used for writing test suites. Assuming you have done `npm install`,
you must run the following before you can run e2e tests ...

`./node_modules/protractor/bin/webdriver-manager update`

Now you can run e2e tests:

1. `./node_modules/protractor/bin/webdriver-manager start --standalone` (start the standalone selenium server)
2. `gulp server` (start the sample app)
3. `./node_modules/protractor/bin/protractor config/protractor.js` (run the tests)

There is a trivial protractor test in `test-e2e`.  Review the config file `config/protractor.js`, and for further
information, see the [Protractor Docs](https://github.com/angular/protractor/blob/master/docs/toc.md).

# Adding Additional JS Libraries

The easiest way to add additional libraries is to use bower to install the library, save the dependency to your bower.json, and then update the `app.vendor` globs
in `config/paths.coffee` as needed. Bower will install these to `vendor\bower\whatever`. Editing the
paths.config file to include the appropriate files explicitly will ensure that concatenation, minification, or other
tasks use the files in the proper sequence.

> This template chooses to take the approach of storing application dependencies in version control, rather than
relying on a `bower install` to pull them all in. The assumption is that you want to manage the application
dependencies more closely than is required for the dev dependencies, which are managed by npm.

# Known Issues
This has been an experiment, and there are a few known issues:
- This attempts to handle errors in a smarter way based on Noah Miller's [Error Handling in Gulp](http://www.artandlogic.com/blog/2014/05/error-handling-in-gulp/), but I think it's subject to overall pipe and error-handling issues in gulp.  Couldn't get it to work as desired (being able to set a "fatal" level from the command line.  Any ideas appreciated.
- Right now you cannot run `gulp test` without first running `gulp build`.  Even though the test task is dependent on the build task, things run in paraellel and the test.js ends up not getting the application files.  Hoping to resolve this when gulp has more effective dependency controls (I know, supposedly callbacks solves this right now, but I can't get it to consistently work).










