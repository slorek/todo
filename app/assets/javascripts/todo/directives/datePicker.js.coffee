angular.module('todo').directive 'datePicker', ->
  {
    link: (scope, element, attrs)->
      $(element).datetimepicker()
  }