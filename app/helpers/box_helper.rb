module BoxHelper
  # :nocov:
  def page_pagination_show?(model)
    collection = model_collection(model)
    "ctrl.#{collection}.total_count > ctrl.#{collection}.page_size"
  end

  def page_pagination(model)
    collection = model_collection(model)
    params = { paging: '',
               page: "ctrl.#{collection}.page",
               total: "ctrl.#{collection}.total_count",
               'paging-action': "ctrl.query(page,ctrl.#{collection}.search,ctrl.#{collection}.filter)",
               'show-prev-next': 'true',
               'show-first-last': 'true',
               'page-size': "ctrl.#{collection}.page_size",
               'ul-class': 'pagination pagination-sm no-margin pull-right',
               'scroll-top': 'true',
               'hide-if-empty': 'true' }

    content_tag :div, class: 'box-tools' do
      content_tag :div, '', params
    end
  end

  def page_filter_search
    content_tag :input, '', class: 'form-control filter-search', type: 'text',
                'ng-model': 'search', placeholder: 'Поиск по странице'
  end

  def page_search(model)
    resource = model_resource(model)
    ng_model = "ctrl.#{resource}.search"
    data_ng_click = "ctrl.query(1,ctrl.#{resource}.search,ctrl.#{resource}.filter)"
    ng_keypress = "($event.which === 13) ? #{data_ng_click} : 0"

    content_tag :div, class: 'input-group' do
      html = text_field_tag :search, nil, class: 'form-control', placeholder: 'Поиск',
                            'ng-model': ng_model, 'ng-keypress': ng_keypress
      html += content_tag :div, class: 'input-group-btn' do
        submit_tag 'Искать', class: 'btn btn-primary btn-flat',
                   'data-ng-click': data_ng_click
      end
      html
    end
  end

  def page_filter_ng_click(model, filter)
    resource = model_resource(model)
    "ctrl.query(1,ctrl.#{resource}.search,#{filter})"
  end

  def page_remove_upload
    params = { class: 'btn btn-danger btn-sm',
               'ng-click': 'ctrl.update(ctrl.task.id, $index)' }
    content_tag :a, params do
      content_tag :i, '', class: 'glyphicon glyphicon-trash'
    end
  end

  def page_filter_ng_repeat(model)
    resource = model_resource(model)
    collection = model_collection(model)
    "#{resource} in ctrl.#{collection}.collection | filter:search"
  end

  def namespace_path(model, namespace = nil)
    collection = model_collection(model)
    namespace.blank? ? model_collection(model) : "#{namespace}/#{collection}"
  end
  # :nocov:
end
