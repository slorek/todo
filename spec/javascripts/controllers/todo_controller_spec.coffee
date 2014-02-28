describe "TodoController", ->

  subject = undefined
  $scope = undefined
  location = undefined
  
  service_mock = {
    get: (sort, completed)->
      then: (response)->
        response(data_mock())
      error: ->
    destroy: ->
      then: (response)->
        response({
          status: 204
        })
      error: ->
    update: (task)->
      then: (response)->
        response({
          status: 204
        })
      error: ->
    create: (task)->
      then: (response)->
        response({
          status: 201
          data: data_mock().data.tasks[0]
        })
      error: ->
    completed: ->
      then: (response)->
        response({
          status: 204
        })
      error: ->
    incomplete: ->
      then: (response)->
        response({
          status: 204
        })
      error: ->
  }
  
  data_mock = ->
    {
      status: 200
      data: {
        pending_count: 5
        completed_count: 10
        tasks: [
          {
            id: 1
            name: 'test'
            due_date: null
            priority: 2
            completed_at: null
          }
        ]
      }
    }
  
  beforeEach ->
    module "todo"
    
    inject ($rootScope, $controller, $q, $routeParams, $location)->
      $scope = $rootScope.$new()
      location = $location
      
      subject = $controller('TodoController', {
        $scope: $scope
        $routeParams
        $location
        TodoService: service_mock
      })
  
  
  describe "destroy", ->
    beforeEach ->
      $scope.$broadcast('$routeChangeSuccess', {});
      spyOn(service_mock, 'destroy').and.callThrough()
      $scope.destroy($scope.data[0])

    it "calls TodoService#destroy", ->
      expect(service_mock.destroy).toHaveBeenCalledWith(data_mock().data.tasks[0].id)

    it "removes the task from the stack", ->
      expect($scope.data.length).toBe 0

    it "decrements the relevant count", ->
      expect($scope.pending_count).toBe 4


  describe "complete", ->
    beforeEach ->
      $scope.$broadcast('$routeChangeSuccess', {});
      spyOn(service_mock, 'completed').and.callThrough()

    it "calls TodoService#completed", ->
      $scope.complete($scope.data[0])
      expect(service_mock.completed).toHaveBeenCalledWith(data_mock().data.tasks[0].id)

    describe "when something went wrong", ->
      beforeEach ->
        service_mock.completed = ->
          then: ->
          error: (response)->
            response('Internal server error', 500)

        $scope.complete($scope.data[0])

      it "sets the error messages to $scope", ->
        expect($scope.edit_error_message).toEqual 'There was a problem updating your task. Please try again.'

    describe "when successful", ->

      beforeEach ->
        $scope.complete($scope.data[0])
        
      it "removes the task from the stack", ->
        expect($scope.data.length).toBe 0

      it "increments completed_count", ->
        expect($scope.completed_count).toBe 11

      it "decrements pending_count", ->
        expect($scope.pending_count).toBe 4
      
      
  describe "incomplete", ->
    beforeEach ->
      location.url('/?completed=true')
      $scope.$broadcast('$routeChangeSuccess', {});
      spyOn(service_mock, 'incomplete').and.callThrough()
    
    it "calls TodoService#incomplete", ->
      $scope.incomplete($scope.data[0])
      expect(service_mock.incomplete).toHaveBeenCalledWith(data_mock().data.tasks[0].id)

    describe "when something went wrong", ->
      beforeEach ->
        service_mock.incomplete = ->
          then: ->
          error: (response)->
            response('Internal server error', 500)

        $scope.incomplete($scope.data[0])

      it "sets the error messages to $scope", ->
        expect($scope.edit_error_message).toEqual 'There was a problem updating your task. Please try again.'

    describe "when successful", ->
      
      beforeEach ->
        $scope.incomplete($scope.data[0])
    
      it "removes the task from the stack", ->
        expect($scope.data.length).toBe 0
    
      it "decrements completed_count", ->
        expect($scope.completed_count).toBe 9
      
      it "increments pending_count", ->
        expect($scope.pending_count).toBe 6
    
  
  describe "routeChangeSuccess", ->
    beforeEach ->
      spyOn(service_mock, 'get').and.callThrough()
      $scope.$broadcast('$routeChangeSuccess', {});
    
    it "gets the data from TodoService", ->
      expect(service_mock.get).toHaveBeenCalledWith('name', false)
      
    it "sets the task data to $scope", ->
      expect($scope.data.length).toEqual 1
    
    it "sets pending_count", ->
      expect($scope.pending_count).toEqual 5
      
    it "sets completed_count", ->
      expect($scope.completed_count).toEqual 10
  
  
  describe "due_date_in_past", ->
    describe "with a date in the past", ->
      it "returns true", ->
        date = '12/12/2011 12:00'
        expect($scope.due_date_in_past(date)).toBe true
    
    describe "with a date in the future", ->
      it "returns false", ->
        date = '12/12/2035 12:00'
        expect($scope.due_date_in_past(date)).toBe false
  
  
  describe "edit", ->
    beforeEach ->
      expect($scope.edited).toEqual null
    
    it "sets the edited task", ->
      $scope.edit(1)
      expect($scope.edited).toEqual 1


  describe "finish_edit", ->
    
    beforeEach ->
      $scope.$broadcast('$routeChangeSuccess', {});
      $scope.edit($scope.data[0])
      spyOn(service_mock, 'update').and.callThrough()
      
    describe "when there are no changes", ->
      beforeEach ->
        $scope.finish_edit()
        
      it "does not call TodoService#update", ->
        expect(service_mock.update).not.toHaveBeenCalled()
      
    describe "when there are changes", ->
      beforeEach ->
        $scope.edited.name = 'edited'
        $scope.finish_edit()
        
      it "calls TodoService#update", ->
        expected_data = data_mock().data.tasks[0]
        expected_data.name = 'edited'
        expect(service_mock.update).toHaveBeenCalledWith(expected_data)
        
    describe "when there are errors", ->
      beforeEach ->
        service_mock.update = ->
          then: ->
          error: (response)->
            response({errors: 'Test'}, 422)

        $scope.edited.name = 'edited'
        $scope.finish_edit()
      
      it "sets the error messages to $scope", ->
        expect($scope.edit_errors).toEqual 'Test'
        
    describe "when something went wrong", ->
      beforeEach ->
        service_mock.update = ->
          then: ->
          error: (response)->
            response('Internal server error', 500)

        $scope.edited.name = 'edited'
        $scope.finish_edit()

      it "sets the error messages to $scope", ->
        expect($scope.edit_error_message).toEqual 'There was a problem updating your task. Please try again.'
    
    describe "cleanup", ->
      beforeEach ->
        $scope.finish_edit()

      it "sets edited to null", ->
        expect($scope.edited).toBe null
        
      it "resets the errors", ->
        expect($scope.edit_errors).toBe null
        expect($scope.edit_error_message).toBe null


  describe "create", ->
    beforeEach ->
      $scope.$broadcast('$routeChangeSuccess', {});
      $scope.new_task = data_mock().data.tasks[0]
      spyOn(service_mock, 'create').and.callThrough()
      spyOn(service_mock, 'get').and.callThrough()

    it "calls TodoService#create", ->
      $scope.create()
      expect(service_mock.create).toHaveBeenCalledWith(data_mock().data.tasks[0])

    describe "when there are errors", ->
      beforeEach ->
        service_mock.create = ->
          then: ->
          error: (response)->
            response({errors: 'Test'}, 422)

        $scope.create()

      it "sets the error messages to $scope", ->
        expect($scope.create_errors).toEqual 'Test'

    describe "when something went wrong", ->
      beforeEach ->
        service_mock.create = ->
          then: ->
          error: (response)->
            response('Internal server error', 500)

        $scope.create()

      it "sets the error messages to $scope", ->
        expect($scope.create_error_message).toEqual 'There was a problem creating your task. Please try again.'
        
    describe "when successful", ->
      beforeEach ->
        $scope.create()

      it "resets new_task", ->
        expect($scope.new_task).toEqual {
          name: null
          due_date: null
          priority: ''
        }

      it "resets the errors", ->
        expect($scope.create_errors).toBe null
        expect($scope.create_error_message).toBe null
      
      it "refreshes the list", ->
        expect(service_mock.get).toHaveBeenCalledWith('name', false)