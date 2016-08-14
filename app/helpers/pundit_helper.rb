module PunditHelper
  def pundit_new_btn(model, namespace = nil)
    resource = model_resource(model)
    params = { class: 'btn btn-success btn-sm',
               'ui-sref': "new_#{model_namespace(namespace)}#{resource}_path",
               'ng-if': "(!ctrl.hide_new_btn && #{policy(model).new?}) || " +
                        'ctrl.show_new_btn' }

    content = content_tag :a, params do
      content_tag :i, '', class: 'glyphicon glyphicon-plus'
    end
    page_header_btn(content)
  end

  def pundit_show_btn(model, namespace = nil)
    resource = model_resource(model)
    ctrl_resource = ctrl_resource(resource)
    ng_if = "(!ctrl.hide_show_btn && #{policy(model).show?}) || ctrl.show_show_btn"
    params = { class: 'btn btn-primary btn-sm',
               'ui-sref': "#{model_namespace(namespace)}#{resource}_path(#{ctrl_resource})",
               'ng-if': ng_if }

    content_tag :td, class: 'w1' do
      content_tag :a, params do
        content_tag :i, '', class: 'glyphicon glyphicon-eye-open'
      end
    end
  end

  def pundit_edit_btn(model, namespace = nil)
    resource = model_resource(model)
    ctrl_resource = ctrl_resource(resource)
    params = { class: 'btn btn-primary btn-sm',
               'ui-sref': "edit_#{model_namespace(namespace)}#{resource}_path(#{ctrl_resource})",
               'ng-if': "(#{ctrl_resource}.id && !ctrl.hide_edit_btn && " +
                        "#{policy(model).edit?}) || ctrl.show_edit_btn",
               'ui-sref-active': 'hidden' }

    content_tag :a, params do
      content_tag :i, '', class: 'glyphicon glyphicon-edit'
    end
  end

  def pundit_destroy_btn(model)
    resource = model_resource(model)
    ctrl_resource = ctrl_resource(resource)
    params = { class: 'btn btn-danger btn-sm',
               'ng-click': "ctrl.destroy(#{ctrl_resource})",
               'ng-if': "(#{ctrl_resource}.id && " +
                        "#{ctrl_resource}.role != 'is_super' && " +
                        "#{policy(model).destroy?} && !ctrl.hide_destroy_btn) || " +
                        "ctrl.show_destroy_btn" }

    content_tag :a, params do
      content_tag :i, '', class: 'glyphicon glyphicon-trash'
    end
  end

  def pundit_show_actions_btn(model, namespace = nil)
    content = pundit_table_actions_btn(model, namespace)
    page_header_btn(content)
  end

  def pundit_table_actions_btn(model, namespace = nil)
    content_tag :td, class: 'w1' do
      pundit_edit_btn(model, namespace) + ' ' + pundit_destroy_btn(model)
    end
  end

  def pundit_permitted_attr?(model, attr_name)
    attrs = [*attr_name]
    permitted_attributes = policy(model).permitted_attributes
    policy = attrs.map { |attr| permitted_attributes.include?(attr) ? attr : nil }
    attrs.count == policy.compact.count
  end

  def pundit_sidebar_menu(model, sref, fa, span)
    return if !policy(model).index?

    content_tag :li, 'ui-sref-active': 'active' do
      content_tag :a, 'ui-sref': sref do
        html = content_tag :i, '', class: "fa #{fa}"
        html += content_tag :span, span
        html
      end
    end
  end

  def page_header_btn(btn = '')
    content_tag :div, btn, class: 'page-header'
  end

  def model_resource(model)
    model.model_name.to_s.underscore
  end

  def model_namespace(namespace)
    namespace.blank? ? '' : "#{namespace}_"
  end

  def model_collection(model)
    model_resource(model).pluralize(3)
  end

  private

  def ctrl_resource(resource)
    actions = ['show', 'edit', 'update', 'create', 'new']
    actions.include?(params[:action]) ? "ctrl.#{resource}" : resource
  end

  def not_permitted_field?(model, field, params)
    !(params[:permit] || pundit_permitted_attr?(model, field))
  end
end
