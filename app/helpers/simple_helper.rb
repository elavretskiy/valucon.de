module SimpleHelper
  # :nocov:
  def simple_group_field(f, field, params = {})
    content_tag :div, class: 'form-group' do
      simple_field(f, field, params)
    end
  end

  def simple_field(f, field, params = {})
    model = params[:model] || f.object.class.name.constantize
    return if not_permitted_field?(model, field, params)
    ng_model = display_ng(model, params[:field] || field, params)

    case true
    when params[:as] == :select
      simple_select_field(f, field, params, ng_model)
    when params[:as] == :association
      simple_association_field(f, field, params, ng_model)
    when params[:as] == :time
      simple_time_field(params, ng_model)
    else
      simple_input_field(f, field, params, ng_model)
    end
  end

  def page_display_field(model, field, params = {})
    return if not_permitted_field?(model, field, params)
    ng_bind = display_ng(model, params[:field] || field, params)
    html = content_tag :dt, model.human_attribute_name(field.to_sym)
    html += content_tag :dd do
      if params[:as] == :link || params[:as] == :field
        page_display_link(model, field, params)
      else
        content_tag :div, '', 'ng-bind': ng_bind
      end
    end
    html
  end

  def page_display_info(model, field, params = {})
    return if not_permitted_field?(model, field, params)
    ng_bind = display_ng(model, params[:field] || field, params)

    content_tag :div, '', 'ng-bind': ng_bind
  end

  def page_display_td(model, field, params = {})
    return if not_permitted_field?(model, field, params)
    ng_bind = display_ng(model, params[:field] || field, params)

    content_tag :td, '', 'ng-bind': ng_bind
  end

  def page_display_th(model, field, params = {})
    return if not_permitted_field?(model, field, params)
    content_tag :th, model.human_attribute_name(field)
  end

  def page_display_link(model, field, params = {})
    return if not_permitted_field?(model, field, params)
    field = params[:join].present? ? "#{params[:join]}.#{params[:field]}" : field
    ng_bind = display_ng(model, field, params)
    path = "#{params[:join] || @resource}_path"
    ui_sref = "#{path}(#{@ctrl_resource}"
    ui_sref += params[:join].present? ? ".#{params[:join]})" : ')'

    content_tag :td do
      if current_user.try(:is_admin?) && !params[:as] == :field
        content_tag :a, '', 'ui-sref': ui_sref, 'ng-bind': ng_bind
      else
        content_tag :div, '', 'ng-bind': ng_bind
      end
    end
  end

  private

  def simple_time_field(params, ng_model)
    html = content_tag :label, class: 'select required control-label' do
      html = content_tag :abbr, '*', title: 'обязательное поле'
      html += " #{params[:label]}"
      html
    end

    params = { 'ng-model': ng_model, 'uib-timepicker': '', 'show-meridian': false }
    html += content_tag :div, '', params
    html
  end

  def simple_association_field(f, field, params, ng_model)
    f.input field,
            label: params[:label],
            collection: params[:collection],
            label_method: params[:label_method] || :name,
            value_method: params[:value_method] || :id,
            include_blank: params[:include_blank],
            class: 'form-control',
            input_html: { 'ng-model': ng_model, 'convert-to-number': '' }
  end

  def simple_select_field(f, field, params, ng_model)
    f.input field,
            label: params[:label],
            collection: params[:collection],
            include_blank: params[:include_blank],
            class: 'form-control',
            input_html: { 'ng-model': ng_model }
  end

  def simple_input_field(f, field, params, ng_model)
    f.input field,
            label: params[:label],
            as: params[:as],
            placeholder: params[:placeholder],
            class: 'form-control',
            input_html: { 'ng-model': ng_model }
  end

  def display_ng(model, field, params)
    @resource = model_resource(model)
    @ctrl_resource = ctrl_resource(@resource)
    ng_bind = "#{@ctrl_resource}.#{field}"
    ng_bind += ' | translate' if params[:translate]
    ng_bind += " | #{params[:datetime][:type] || :date}:'#{params[:datetime][:format]}'" if params[:datetime]
    ng_bind
  end
  # :nocov:
end
