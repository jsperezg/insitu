# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # adjust the attributes here as well.
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
      get :index, params: { project_id: project.id }, format: :json
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task as @task' do
      task = Task.create! valid_attributes
      get :show, params: { project_id: project, id: task.to_param }, format: :json
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Task' do
        expect do
          post :create, params: { project_id: project.to_param, task: valid_attributes }, format: :json
        end.to change(Task, :count).by(1)
      end

      it 'assigns a newly created task as @task' do
        post :create, params: { project_id: project.to_param, task: valid_attributes }, format: :json
        expect(assigns(:task)).to be_a(Task)
        expect(assigns(:task)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { project_id: project.to_param, task: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved task as @task' do
        post :create, params: { project_id: project.to_param, task: invalid_attributes }, format: :json
        expect(assigns(:task)).to be_a_new(Task)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :task
      end

      let(:task) { Task.create! valid_attributes }

      it 'updates the requested task' do
        put :update, params: { project_id: project.to_param, id: task.to_param, task: new_attributes }, format: :json
        task.reload

        new_attributes.each do |key, value|
          expect(task[key]).to eq(value)
        end
      end

      it 'assigns the requested task as @task' do
        put :update, params: { project_id: project.to_param, id: task.to_param, task: valid_attributes }, format: :json
        expect(assigns(:task)).to eq(task)
      end

      it 'returns 200 - ok' do
        put :update, params: { project_id: project.to_param, id: task.to_param, task: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the task as @task' do
        task = Task.create! valid_attributes
        put :update,
            params: { project_id: project.to_param, id: task.to_param, task: invalid_attributes },
            format: :json
        expect(assigns(:task)).to eq(task)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = Task.create! valid_attributes
      expect do
        delete :destroy, params: { project_id: project.to_param, id: task.to_param }, format: :json
      end.to change(Task, :count).by(-1)
    end

    it 'returns 200 - ok' do
      task = Task.create! valid_attributes
      delete :destroy, params: { project_id: project, id: task.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #invoice_finished' do
    before do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    let(:task) { Task.create! valid_attributes }

    it 'Warns when nothing to invoice' do
      get :invoice_finished, params: { user_id: user.to_param, project_id: project.to_param }, format: :json
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('tasks.no_pending_tasks'))
    end

    it 'Generates invoice with all pending time logs' do
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

      get :invoice_finished, params: { user_id: user.to_param, project_id: project.to_param }, format: :json

      task.reload

      task.time_logs.each do |time_log|
        expect(time_log.invoice_detail_id).not_to be_nil

        expect(time_log.invoice_detail.description).to eq(time_log.description)
        expect(time_log.invoice_detail.quantity).to eq(time_log.time_spent / 60)
        expect(time_log.invoice_detail.service_id).to eq(time_log.service_id)
        expect(time_log.invoice_detail.vat_rate).not_to be_nil
        expect(time_log.invoice_detail.price).not_to be_nil

        expect(response).to have_http_status(:ok)
      end
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

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

      get :invoice_finished, params: { user_id: user.to_param, project_id: project.to_param }, format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('payment_methods.not_found'))
    end
  end
end
