angular.module('todo').directive 'datePicker', ->
  {
    link: (scope, element, attrs)->
      $(element).datetimepicker
        defaultDate: moment(scope.edited.due_date, 'DD/MM/YYYY HH:mm')
  }