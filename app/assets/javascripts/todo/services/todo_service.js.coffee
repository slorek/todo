angular.module('todo').factory 'TodoService', ['$http', ($http) ->
  {
    get: (sort, completed)->
      
      params = {
        sort: sort
      }
      params['completed'] = true if completed
      
      $http
        method: "GET"
        url: '/tasks.json'
        params: params

    create: (new_task)->
      $http
        method: "POST"
        url: "/tasks.json"
        params: {
          'task[name]': new_task.name || ''
          'task[priority]': new_task.priority || ''
          'task[due_date]': new_task.due_date || ''
        }

    update: (task)->
      $http
        method: "PATCH"
        url: "/tasks/#{task.id}.json"
        params: {
          'task[name]': task.name || ''
          'task[priority]': task.priority || ''
          'task[due_date]': task.due_date || ''
        }

    destroy: (id)->
      $http
        method: "DELETE"
        url: "/tasks/#{id}.json"

    completed: (id)->
      $http
        method: "PATCH"
        url: "/tasks/#{id}/completed.json"

    incomplete: (id)->
      $http
        method: "PATCH"
        url: "/tasks/#{id}/incomplete.json"
  }
]
