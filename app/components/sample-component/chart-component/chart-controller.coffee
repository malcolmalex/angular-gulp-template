# This is a controller to handle interactions with the sample chart
angular.module("SampleApp").controller "ChartController", [
  '$scope'
  'Restangular'
  ($scope, Restangular) ->

    $scope.xAxisTickFormat = ->
      (d) ->
        d3.format ".4g"

    # For the heck of it, get the data from the embedded express server
    # kind of like you might do with a real REST backend.
    $scope.exampleData = Restangular.all('chartData').getList().$object
]



