require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TimeLogsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # TimeLog. As you add validations to TimeLog, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:time_log)
  }

  let(:invalid_attributes) {
    attributes_for(:time_log, start_time: DateTime.now, end_time: DateTime.now - 1.hour)
  }

  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user
  end

  after(:each) do
    sign_out @user
  end

  describe "GET #index" do
    it "assigns all time_logs as @time_logs" do
      time_log = TimeLog.create! valid_attributes
      get :index, { user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id }
      expect(assigns(:time_logs)).to eq([time_log])
    end
  end

  describe "GET #show" do
    it "assigns the requested time_log as @time_log" do
      time_log = TimeLog.create! valid_attributes
      get :show, { user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, id: time_log.to_param}
      expect(assigns(:time_log)).to eq(time_log)
    end
  end

  describe "GET #new" do
    it "assigns a new time_log as @time_log" do
      project = Project.first || create(:project)
      task = Task.first || create(:task)

      get :new, { user_id: @user, project_id: project.id, task_id: task.id }
      expect(assigns(:time_log)).to be_a_new(TimeLog)
    end
  end

  describe "GET #edit" do
    it "assigns the requested time_log as @time_log" do
      time_log = TimeLog.create! valid_attributes
      get :edit, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, id: time_log.to_param}
      expect(assigns(:time_log)).to eq(time_log)
    end
  end

  describe "POST #create" do
    before(:each) do
      @project = Project.first || create(:project)
      @task = Task.first || create(:task)
    end
    context "with valid params" do
      it "creates a new TimeLog" do
        expect {
          post :create, {user_id: @user, project_id: @project.id, task_id: @task.id, :time_log => valid_attributes}
        }.to change(TimeLog, :count).by(1)
      end

      it "assigns a newly created time_log as @time_log" do
        post :create, {user_id: @user, project_id: @project.id, task_id: @task.id, :time_log => valid_attributes}
        expect(assigns(:time_log)).to be_a(TimeLog)
        expect(assigns(:time_log)).to be_persisted
      end

      it "redirects to the time log list" do
        post :create, {user_id: @user, project_id: @project.id, task_id: @task.id, :time_log => valid_attributes}
        expect(response).to redirect_to(user_project_task_time_logs_path(user_id: @user, project_id: @project.id, task_id: @task.id))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved time_log as @time_log" do
        post :create, {user_id: @user, project_id: @project.id, task_id: @task.id, :time_log => invalid_attributes}
        expect(assigns(:time_log)).to be_a_new(TimeLog)
      end

      it "re-renders the 'new' template" do
        post :create, {user_id: @user, project_id: @project.id, task_id: @task.id, :time_log => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:time_log)
      }

      it "updates the requested time_log" do
        time_log = TimeLog.create! valid_attributes
        put :update, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, id: time_log.to_param, time_log: new_attributes}
        time_log.reload

        new_attributes.each do |key, value|
          if key == :start_time or key == :end_time
            expect(I18n.l(time_log[key].utc, format: :long)).to eq(I18n.l(value.utc, format: :long))
          else
            expect(time_log[key]).to eq(value)
          end
        end
      end

      it "assigns the requested time_log as @time_log" do
        time_log = TimeLog.create! valid_attributes
        put :update, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, :id => time_log.to_param, :time_log => valid_attributes}
        expect(assigns(:time_log)).to eq(time_log)
      end

      it "redirects to the time_log list" do
        time_log = TimeLog.create! valid_attributes
        put :update, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, :id => time_log.to_param, :time_log => valid_attributes}
        expect(response).to redirect_to(user_project_task_time_logs_path(user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task.id))
      end
    end

    context "with invalid params" do
      it "assigns the time_log as @time_log" do
        time_log = TimeLog.create! valid_attributes
        put :update, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id,:id => time_log.to_param, :time_log => invalid_attributes}
        expect(assigns(:time_log)).to eq(time_log)
      end

      it "re-renders the 'edit' template" do
        time_log = TimeLog.create! valid_attributes
        put :update, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id,:id => time_log.to_param, :time_log => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested time_log" do
      time_log = TimeLog.create! valid_attributes
      expect {
        delete :destroy, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id,:id => time_log.to_param}
      }.to change(TimeLog, :count).by(-1)
    end

    it "redirects to the time_logs list" do
      time_log = TimeLog.create! valid_attributes
      delete :destroy, {user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task_id, :id => time_log.to_param}
      expect(response).to redirect_to(user_project_task_time_logs_path(user_id: @user, project_id: time_log.task.project_id, task_id: time_log.task.id))
    end
  end

end
