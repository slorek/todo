todo = angular.module('todo', ['ngRoute']).config ['$routeProvider', ($routeProvider)->
  
  $routeProvider.when('/', {
  	controller: 'TodoController',
  	templateUrl: 'table.html'
  	
  }).otherwise {
  	redirectTo: '/'
  }
]


onFormBlur = null

$(document).on('blur', '#edit-task input, #edit-task select, #edit-task button', ->
  input = $(this)
  onFormBlur = setTimeout ->
    input.parents('form').trigger('blur')
  , 100

).on('focus', '#edit-task input, #edit-task select, #edit-task button', ->
   clearTimeout(onFormBlur)
)
