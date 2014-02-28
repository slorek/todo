angular.module('todo').filter 'translatePriority', ->
  (priority)->
    translations = {
      '1' : 'Low'
      '2' : 'Minor'
      '3' : 'Normal'
      '4' : 'High'
      '5' : 'Urgent'
    }
    
    translations[priority]