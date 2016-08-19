require 'rails_helper'

describe ApplicationHelper do
  describe 'Breadcrumbs' do
    describe 'text' do
      it 'index' do
        text = Breadcrumbs.text({ action: 'index' })
        expect(text).to eq 'Список'
      end

      it 'show' do
        text = Breadcrumbs.text({ action: 'show' })
        expect(text).to eq 'Просмотр'
      end

      it 'edit' do
        text = Breadcrumbs.text({ action: 'edit' })
        expect(text).to eq 'Редактирование'
      end

      it 'update' do
        text = Breadcrumbs.text({ action: 'update' })
        expect(text).to eq 'Редактирование'
      end

      it 'new' do
        text = Breadcrumbs.text({ action: 'new' })
        expect(text).to eq 'Создание'
      end

      it 'create' do
        text = Breadcrumbs.text({ action: 'create' })
        expect(text).to eq 'Создание'
      end
    end

    describe 'path' do
      it 'index' do
        path = Breadcrumbs.path({ action: 'index' }, Task)
        expect(path).to eq 'tasks_path'
      end

      it 'show' do
        path = Breadcrumbs.path({ action: 'show' }, Task)
        expect(path).to eq 'task_path'
      end

      it 'edit' do
        path = Breadcrumbs.path({ action: 'edit' }, Task)
        expect(path).to eq 'edit_task_path'
      end

      it 'update' do
        path = Breadcrumbs.path({ action: 'update' }, Task)
        expect(path).to eq 'edit_task_path'
      end
    end
  end
end
