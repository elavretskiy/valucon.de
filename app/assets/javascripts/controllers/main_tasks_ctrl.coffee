app.controller 'MainTasksCtrl', [
  'Task'
  'action'
  (Model, action) ->
    ctrl = this

    $('.loading').show()

    ctrl.hide_new_btn = true

    action 'index', (params) ->
      ctrl.query = (page, search) ->
        $('.loading').show()
        Model.get { page: page, search: search }, (res) ->
          ctrl.tasks = res
      ctrl.query 1
]
