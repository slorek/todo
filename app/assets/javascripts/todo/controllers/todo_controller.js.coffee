angular.module('todo').controller('TodoController', ['$scope', '$routeParams', '$location', 'TodoService', ($scope, $routeParams, $location, TodoService) ->
  
  $scope.data = []
  $scope.pending_count = 0
  $scope.completed_count = 0
  $scope.sort = 'name'
  $scope.old_data = null
  $scope.edited = null
  $scope.create_error_message = null
  $scope.create_errors = null
  $scope.edit_error_message = null
  $scope.edit_errors = null
  
  $scope.new_task = {
    name: null
    due_date: null
    priority: ''
  }
  
  $scope.sort_url = (sort)->
	  params = $location.search()
	  
	  output = []
	  
	  for key,value of params
	    if key != 'sort'
	      output.push "#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"
	  
    if sort != null
      output.push "sort=#{encodeURIComponent(sort)}"
    
	  output.join("&")
		
  $scope.destroy = (task)->
    promise = TodoService.destroy(task.id)
    
    promise.then (response) ->
      if response.status == 204
        remove_task(task)

    promise.error ->
      $scope.edit_error_message = 'There was a problem deleting your task. Please try again.'
    	    
  $scope.complete = (task)->
    promise = TodoService.completed(task.id)
    
    promise.then (response) ->
      if response.status == 204
        $scope.completed_count += 1
        remove_task(task)

    promise.error ->
      $scope.edit_error_message = 'There was a problem updating your task. Please try again.'

  $scope.incomplete = (task)->
    promise = TodoService.incomplete(task.id)
    
    promise.then (response) ->
      if response.status == 204
        $scope.pending_count += 1
        remove_task(task)
    
    promise.error ->
      $scope.edit_error_message = 'There was a problem updating your task. Please try again.'
    
  
  $scope.edit = (task)->
    $scope.edited = task
    
    $scope.old_data = {
      name: task.name
      due_date: task.due_date
      priority: task.priority
    }

  $scope.finish_edit = ()->
    if ($scope.edited.name == $scope.old_data.name) && ($scope.edited.due_date == $scope.old_data.due_date) && ($scope.edited.priority == $scope.old_data.priority)
      $scope.edited = null
      $scope.edit_errors = null
      $scope.edit_error_message = null
      return
    
    promise = TodoService.update($scope.edited)
    
    promise.then (response) ->
      if response.status == 204
        $scope.edited = null
        $scope.edit_errors = null
        $scope.edit_error_message = null
        
        refresh_list()
    
    promise.error((response, status) ->
      if status == 422
        $scope.edit_errors = response.errors
      else
        $scope.edit_error_message = 'There was a problem updating your task. Please try again.'
    )
    
  $scope.create = ->
    promise = TodoService.create($scope.new_task)
    
    promise.then((response) ->
      if response.status == 201
        $scope.create_errors = null
        $scope.create_error_message = null
        $scope.new_task = {
          name: null
          due_date: null
          priority: ''
        }
        
        refresh_list()
    )
    
    promise.error((response, status) ->
      if status == 422
        $scope.create_errors = response.errors
      else
        $scope.create_error_message = 'There was a problem creating your task. Please try again.'
    )

  $scope.due_date_in_past = (due_date)->
    moment(due_date, 'DD/MM/YYYY HH:mm').isBefore(moment())
    
  remove_task = (task)->
    if active_tab() == 'pending'
      $scope.pending_count -= 1
    else
      $scope.completed_count -= 1
    
    $scope.data.splice($scope.data.indexOf(task), 1);
    
  active_tab = ->
    if $location.search().completed != undefined then 'completed' else 'pending'
  
  # Convert dates from JSON format to date picker input format
  format_date = (date)->
    moment(date).format("DD/MM/YYYY HH:mm")
  
  refresh_list = ()->
    completed = $location.search().completed != undefined
    sort = $location.search().sort || 'name'

    $scope.completed = completed
    $scope.sort = sort

    TodoService.get(sort, completed).then (response) ->

      # Format due dates for date picker
      $scope.data = response.data.tasks.map (task)->
        if task.due_date != null
          task.due_date = format_date(task.due_date)
        task

      $scope.pending_count = response.data.pending_count
      $scope.completed_count = response.data.completed_count
  
  $scope.$on '$routeChangeSuccess', refresh_list
])