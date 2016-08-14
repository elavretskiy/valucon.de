module TaskHelper
  def task_state_link
    params = { 'ng-class': 'ctrl.stateBtn(task.state)',
               'ng-click': 'ctrl.update(task.id,nil,ctrl.stateEvent(task.state),$index)',
               'ng-if': 'ctrl.stateEvent(task.state)' }

    content_tag :a, params do
      content_tag :i, '', 'ng-class': 'ctrl.stateIcon(task.state)'
    end
  end
end
