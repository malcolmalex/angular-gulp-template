angular.module("SampleApp").controller "TodoController", [
  '$scope'
  '$http'
  'Restangular'
  ($scope, $http, Restangular) ->

    # The $http way ...
    #    $http.get('/todos').success (data) ->
    #      $scope.todos = data

    # Restangular retrieval of todos (which uses promises)
    $scope.todos = Restangular.all('todos').getList().$object

    # Add a todo, bound to the text-field in view by todoText,
    # and after added reset the todoText to '' to clear it out
    $scope.addTodo = () ->
      $scope.todos.push {text : $scope.todoText, done : false}
      $scope.todoText = ''

    # For calculating remaining todos.  Loop through them, counting
    # any not done
    $scope.remaining = () ->
      # TODO: There is an easier way - fix at some point
      count = 0
      for todo in $scope.todos
        count = if !todo.done then count += 1 else count

      return count

    # Drops the todo array, reloading any that are not done
    $scope.archive = () ->
      oldTodos = $scope.todos
      $scope.todos = []
      angular.forEach oldTodos, (todo) ->
        if !todo.done then $scope.todos.push todo
  ]