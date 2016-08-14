app.controller 'AdminSessionsCtrl', [
  'AdminSession'
  'action'
  (Model, action) ->
    ctrl = this

    action 'new', ->
      ctrl.user = Model.new()
      ctrl.save = Model.create
]
