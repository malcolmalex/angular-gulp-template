angular.module("SampleApp", [
  "ngResource"
  "restangular"
  "ui.bootstrap"
  "ui.router"
  "pascalprecht.translate"
  "nvd3ChartDirectives"
]).run ($rootScope, Restangular, $state, $stateParams) ->
  
  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) ->
    console.log thing

  $rootScope.alert = (thing) ->
    alert thing

  # To change the class on the navbar, need these variables available on root
  # scope
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

# NOTE: URLS are of the form http://localhost:8000/#/something
angular.module("SampleApp").config (
  $stateProvider,
  $urlRouterProvider,
  $translateProvider,
  RestangularProvider) ->

  # TODO: At some point, configure translationProvider and test.
  
  # For any unmatched url, send to /route1
  $urlRouterProvider.otherwise "/todo-main"

  # TODO: Can gulp glob processing handle multiple periods in filenames?
  # This would allow templates that are named like nested routes, instead
  # of using `-` like had to do with linemanJS
  $stateProvider
    .state 'todo',
      url : "/todo-main"
      templateUrl : "sample-component/todo-component/todo-main.html"

    .state 'todo.detail',
      url : "/detail"
      templateUrl : "sample-component/todo-component/todo-detail.html"
      controller : "TodoController"

    .state 'accordian',
      url : "/accordian-main"
      templateUrl : "sample-component/accordian-component/accordian-main.html"

    .state 'accordian.detail',
      url : "/detail"
      templateUrl : "sample-component/accordian-component/accordian-detail.html"
      controller : "AccordianController"

    .state 'chart',
      url : '/chart'
      templateUrl : "sample-component/chart-component/chart-main.html"
      controller : "ChartController"

  return