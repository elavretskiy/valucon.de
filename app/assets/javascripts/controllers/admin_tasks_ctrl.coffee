app.controller 'AdminTasksCtrl', [
  'AdminTask'
  'action'
  '$state'
  (Model, action, $state) ->
    ctrl = this

    $('.loading').show()

    ctrl.show_show_btn = true
    ctrl.show_edit_btn = true
    ctrl.show_destroy_btn = true

    action 'index', (params) ->
      ctrl.stateEvent = (state) ->
        switch true
          when state == 'new'
            'to_started'
          when state == 'started'
            'to_finished'
          when state == 'finished'
            null

      ctrl.stateIcon = (state) ->
        switch true
          when state == 'new'
            'glyphicon glyphicon-new-window'
          when state == 'started'
            'glyphicon glyphicon-check'
          when state == 'finished'
            null

      ctrl.stateBtn = (state) ->
        switch true
          when state == 'new'
            'btn btn-sm btn-info'
          when state == 'started'
            'btn btn-sm btn-warning'
          when state == 'finished'
            null

      ctrl.query = (page, search, filter) ->
        $('.loading').show()
        Model.get { page: page, search: search, filter: filter }, (res) ->
          ctrl.tasks = res
      ctrl.query 1

    action 'show', (params) ->
      ctrl.task = Model.get(id: params.id)

      ctrl.uploadName = (url) ->
        decodeURIComponent(url.split('/').pop())

      ctrl.isImage = (url) ->
        re = /(?:\.([^.]+))?$/;
        ext = re.exec(url)[1];
        images = ['jpg', 'jpeg', 'png', 'gif']
        ext in images

      ctrl.reload = ->
        $state.reload()

    action 'new', ->
      ctrl.show_edit_btn = false
      ctrl.show_destroy_btn = false

      ctrl.task = Model.new()
      ctrl.save = Model.create

    action 'edit', (params) ->
      ctrl.show_edit_btn = false
      ctrl.hide_edit_btn = true

      ctrl.task = Model.edit(id: params.id)
      ctrl.save = Model.update

    action [
      'index'
      'show'
    ], ->
      ctrl.update = (id, remove_upload, state_event, index, params)->
        $('.loading').show()
        Model.update { id: id, remove_upload: remove_upload, task: { id: id, state_event: state_event } }, (res) ->
          if remove_upload == undefined
            ctrl.tasks.collection[index] = res.task
          else
            $state.reload()

    action [
      'index'
      'edit'
      'show'
    ], ->
      ctrl.destroy = (task) ->
        $('.loading').show()
        if (confirm("Вы уверены?"))
          Model.destroy { id: task.id }, ->
            if ctrl.tasks
              ctrl.tasks.collection = _.select(ctrl.tasks.collection, (_task) ->
                _task.id != task.id
              )
]
