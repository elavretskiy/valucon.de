class Breadcrumbs
  class << self
    def text(params)
      case params[:action]
      when 'index'
        'Список'
      when 'show'
        'Просмотр'
      when 'edit', 'update'
        'Редактирование'
      when 'new', 'create'
        'Создание'
      end
    end

    def path(params, model)
      model_name = model.model_name.to_s.underscore
      case params[:action]
      when 'index'
        "#{model_name.plural}_path"
      when 'show'
        "#{model_name}_path"
      when 'edit', 'update'
        "edit_#{model_name}_path"
      end
    end
  end
end
