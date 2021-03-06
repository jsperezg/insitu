# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Service. As you add validations to Service, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for :plan
  end

  let(:invalid_attributes) do
    attributes = attributes_for :plan
    attributes[:price] = nil
    attributes
  end

  let(:user) { create(:user, :admin) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all plans as @plans' do
      plan = Plan.create! valid_attributes
      get :index
      expect(assigns(:plans)).to include(plan)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested plan as @plan' do
      plan = Plan.create! valid_attributes
      get :show, params: { id: plan.to_param }
      expect(assigns(:plan)).to eq(plan)
    end
  end

  describe 'GET #new' do
    it 'assigns a new plan as @plan' do
      get :new
      expect(assigns(:plan)).to be_a_new(Plan)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested plan as @plan' do
      plan = Plan.create! valid_attributes
      get :edit, params: { id: plan.to_param }
      expect(assigns(:plan)).to eq(plan)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Plan' do
        expect do
          post :create, params: { plan: valid_attributes }
        end.to change(Plan, :count).by(1)
      end

      it 'assigns a newly created plan as @plan' do
        post :create, params: { plan: valid_attributes }
        expect(assigns(:plan)).to be_persisted
      end

      it 'redirects to the plans list' do
        post :create, params: { plan: valid_attributes }
        expect(response).to redirect_to(plans_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved plan as @plan' do
        post :create, params: { plan: invalid_attributes }
        expect(assigns(:plan)).to be_a_new(Plan)
      end

      it "re-renders the 'new' template" do
        post :create, params: { plan: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :plan
      end

      let(:plan) { Plan.create! valid_attributes }

      it 'updates the requested plan' do
        put :update, params: { id: plan.to_param, plan: new_attributes }
        plan.reload

        expect(plan.description).to eq(new_attributes[:description])
        expect(plan.months).to eq(new_attributes[:months])
        expect(plan.price).to eq(new_attributes[:price])
      end

      it 'assigns the requested plan as @plan' do
        put :update, params: { id: plan.to_param, plan: valid_attributes }
        expect(assigns(:plan)).to eq(plan)
      end

      it 'redirects to the plan' do
        put :update, params: { id: plan.to_param, plan: valid_attributes }
        expect(response).to redirect_to(plan)
      end
    end

    context 'with invalid params' do
      it 'assigns the plan as @plan' do
        plan = Plan.create! valid_attributes
        put :update, params: { id: plan.to_param, plan: invalid_attributes }
        expect(assigns(:plan)).to eq(plan)
      end

      it "re-renders the 'edit' template" do
        plan = Plan.create! valid_attributes
        put :update, params: { id: plan.to_param, plan: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested plan' do
      plan = Plan.create! valid_attributes
      expect do
        delete :destroy, params: { id: plan.to_param }
      end.to change(Plan, :count).by(-1)
    end

    it 'redirects to the plans list' do
      plan = Plan.create! valid_attributes
      delete :destroy, params: { id: plan.to_param }
      expect(response).to redirect_to(plans_url)
    end
  end
end
