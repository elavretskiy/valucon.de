app.controller 'AdminSessionsCtrl', [
  'AdminSession'
  'action'
  (Model, action) ->
    ctrl = this

    $('.loading').show()

    action 'new', ->
      ctrl.user = Model.new()
      ctrl.save = Model.create
]
