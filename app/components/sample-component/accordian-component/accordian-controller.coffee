# This is a controller to handle interactions with the accordian
angular.module("SampleApp").controller "AccordianController", [
  '$scope'
  ($scope) ->

    # Should one accordian panel be open at a time, or multiple?
    $scope.oneAtATime = true

    # Dummy data
    $scope.groups = [
      {
        title : 'Dynamic Group Header - 1',
        content : 'Dynamic Group Body - 1'
      },
      {
        title : 'Dynamic Group Header - 2',
        content : 'Dynamic Group Body - 2'
      }
    ]

    $scope.items = ['Item 1', 'Item 2', 'Item 3']

    # function to demonstrate adding dynamic content to the contents of
    # an accordian panel
    $scope.addItem = ->
      newItemNo = $scope.items.length + 1
      $scope.items.push('Item ' + newItemNo)

    $scope.status =
      isFirstOpen : true,
      isFirstDisabled : false
  ]