require 'rails_helper'

describe TasksHelper do
  it 'task_state_link' do
    link = '<a ng-class="ctrl.stateBtn(task.state)" ng-click="ctrl.update(task.id,nil,ctrl.stateEvent(task.state),$index)" ng-if="ctrl.stateEvent(task.state)"><i ng-class="ctrl.stateIcon(task.state)"></i></a>'
    expect(helper.task_state_link).to eq link
  end
end
