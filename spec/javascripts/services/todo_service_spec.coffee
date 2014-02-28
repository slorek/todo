describe "TodoService", ->

  subject = undefined
  httpBackend = undefined
  
  beforeEach ->
    module "todo"
    inject (TodoService, $httpBackend) ->
      subject = TodoService
      httpBackend = $httpBackend
      
  describe "#get", ->

    it "returns a promise", ->
      expect(subject.get('name', null)).toBePromise
          
    describe 'sort argument', ->
      it 'sends as a parameter to the HTTP request', ->
        httpBackend.expectGET('/tasks.json?sort=due_date').respond(200, '')
        subject.get('due_date', null)
        httpBackend.flush()

      describe 'completed argument', ->
        describe 'when null', ->
          it 'does not send as a parameter to the HTTP request', ->
            httpBackend.expectGET('/tasks.json?sort=due_date').respond(200, '')
            subject.get('due_date', null)
            httpBackend.flush()
            
        describe 'when not null', ->
          it 'sends as a parameter to the HTTP request', ->
            httpBackend.expectGET('/tasks.json?completed=true&sort=due_date').respond(200, '')
            subject.get('due_date', true)
            httpBackend.flush()
    
  describe "#create", ->

    it "returns a promise", ->
      expect(subject.create({})).toBePromise

    it 'sends the HTTP request', ->
      httpBackend.expectPOST('/tasks.json?task%5Bdue_date%5D=&task%5Bname%5D=test&task%5Bpriority%5D=').respond(201, '')
      subject.create({
        name: 'test'
        priority: null
        due_date: null
      })
      httpBackend.flush()

  describe "#update", ->

    it "returns a promise", ->
      expect(subject.update({})).toBePromise

    it 'sends the HTTP request', ->
      httpBackend.expectPATCH('/tasks/1.json?task%5Bdue_date%5D=&task%5Bname%5D=&task%5Bpriority%5D=').respond(204, '')
      subject.update({
        id: 1
      })
      httpBackend.flush()

  describe "#destroy", ->

    it "returns a promise", ->
      expect(subject.destroy(1)).toBePromise

    it 'sends the HTTP request', ->
      httpBackend.expectDELETE('/tasks/1.json').respond(204, '')
      subject.destroy(1)
      httpBackend.flush()

  describe "#completed", ->

    it "returns a promise", ->
      expect(subject.completed(1)).toBePromise

    it 'sends the HTTP request', ->
      httpBackend.expectPATCH('/tasks/1/completed.json').respond(204, '')
      subject.completed(1)
      httpBackend.flush()

  describe "#incomplete", ->

    it "returns a promise", ->
      expect(subject.incomplete(1)).toBePromise

    it 'sends the HTTP request', ->
      httpBackend.expectPATCH('/tasks/1/incomplete.json').respond(204, '')
      subject.incomplete(1)
      httpBackend.flush()

