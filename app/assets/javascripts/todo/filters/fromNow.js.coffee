angular.module('todo').filter 'fromNow', ->
  (date)->
    moment(date, 'DD/MM/YYYY HH:mm').fromNow()