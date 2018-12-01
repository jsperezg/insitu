# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:valid_attributes) do
    attributes_for :task
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  let(:user) { User.first || create(:user) }
  let(:project) { Project.first || create(:project) }

  before do
    sign_in user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all tasks as @tasks' do
      task = Task.create! valid_attributes
      get :index, user_id: user.id, project_id: project.id
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task as @task' do
      task = Task.create! valid_attributes
      get :show, user_id: user, project_id: project, id: task.to_param
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task as @task' do
      get :new, user_id: user, project_id: project
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested task as @task' do
      task = Task.create! valid_attributes
      get :edit, user_id: user, project_id: project, id: task.to_param
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Task' do
        expect do
          post :create, user_id: user, project_id: project, task: valid_attributes
        end.to change(Task, :count).by(1)
      end

      it 'assigns a newly created task as @task' do
        post :create, user_id: user, project_id: project, task: valid_attributes
        expect(assigns(:task)).to be_a(Task)
        expect(assigns(:task)).to be_persisted
      end

      it 'redirects to the tasks list' do
        post :create, user_id: user, project_id: project, task: valid_attributes
        expect(response).to redirect_to(edit_user_project_task_url(user, project, Task.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved task as @task' do
        post :create, user_id: user, project_id: project, task: invalid_attributes
        expect(assigns(:task)).to be_a_new(Task)
      end

      it "re-renders the 'new' template" do
        post :create, user_id: user, project_id: project, task: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :task
      end

      it 'updates the requested task' do
        task = Task.create! valid_attributes
        put :update, user_id: user, project_id: project, id: task.to_param, task: new_attributes
        task.reload

        new_attributes.each do |key, value|
          expect(task[key]).to eq(value)
        end
      end

      it 'assigns the requested task as @task' do
        task = Task.create! valid_attributes
        put :update, user_id: user, project_id: project, id: task.to_param, task: valid_attributes
        expect(assigns(:task)).to eq(task)
      end

      it 'redirects to the tasks list' do
        task = Task.create! valid_attributes
        put :update, user_id: user, project_id: project, id: task.to_param, task: valid_attributes
        expect(response).to redirect_to(edit_user_project_task_url(user, project, task))
      end
    end

    context 'with invalid params' do
      it 'assigns the task as @task' do
        task = Task.create! valid_attributes
        put :update, user_id: user, project_id: project, id: task.to_param, task: invalid_attributes
        expect(assigns(:task)).to eq(task)
      end

      it "re-renders the 'edit' template" do
        task = Task.create! valid_attributes
        put :update, user_id: user, project_id: project, id: task.to_param, task: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = Task.create! valid_attributes
      expect do
        delete :destroy, user_id: user, project_id: project, id: task.to_param
      end.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      task = Task.create! valid_attributes
      delete :destroy, user_id: user, project_id: project, id: task.to_param
      expect(response).to redirect_to(user_project_tasks_url(user, project))
    end
  end

  describe 'GET #invoice_finished' do
    before do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    it 'Warns when nothing to invoice' do
      _task = Task.create! valid_attributes

      get :invoice_finished, user_id: user, project_id: project
      expect(response).to redirect_to(user_project_tasks_path(user, project))
      expect(flash[:alert]).to eq(I18n.t('tasks.no_pending_tasks'))
    end

    it 'Generates invoice with all pending time logs' do
      task = Task.create! valid_attributes
      2.times do |i|
        TimeLog.create!(
          description: "time log #{i + 1}",
          date: Date.today,
          time_spent: (i + 1) * 60,
          task_id: task.id,
          service_id: Service.first.id
        )
      end

      task.finish_date = Date.today
      task.save

      get :invoice_finished, user_id: user, project_id: project

      task.reload

      task.time_logs.each do |time_log|
        expect(time_log.invoice_detail_id).not_to be_nil

        expect(time_log.invoice_detail.description).to eq(time_log.description)
        expect(time_log.invoice_detail.quantity).to eq(time_log.time_spent / 60)
        expect(time_log.invoice_detail.service_id).to eq(time_log.service_id)
        expect(time_log.invoice_detail.vat_rate).not_to be_nil
        expect(time_log.invoice_detail.price).not_to be_nil

        expect(response).to redirect_to(edit_user_invoice_path(user, time_log.invoice_detail.invoice_id))
      end
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

      task = Task.create! valid_attributes
      2.times do |i|
        TimeLog.create!(
          description: "time log #{i + 1}",
          date: Date.today,
          time_spent: (i + 1) * 60,
          task_id: task.id,
          service_id: Service.first.id
        )
      end

      task.finish_date = Date.today
      task.save

      get :invoice_finished, user_id: user, project_id: project

      expect(response).to redirect_to user_project_tasks_path(user.id, project)
      expect(flash[:alert]).to eq(I18n.t('payment_methods.not_found'))
    end
  end
end
