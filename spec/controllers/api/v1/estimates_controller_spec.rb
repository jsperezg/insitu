require 'rails-controller-testing'
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

RSpec.describe Api::V1::EstimatesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Estimate. As you add validations to Estimate, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    estimate = attributes_for(:estimate)

    estimate.merge(estimate_details_attributes: [ attributes_for(:estimate_detail, estimate_id: nil) ])
  }

  let(:invalid_attributes) {
    attributes_for(:estimate, customer_id: nil)
  }

  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user
  end

  after(:each) do
    sign_out @user
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EstimatesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all estimates as @estimates' do
      estimate = Estimate.create! valid_attributes
      get :index
      expect(assigns(:estimates)).to eq([estimate])
    end
  end

  describe "GET #show" do
    it "assigns the requested estimate as @estimate" do
      estimate = Estimate.create! valid_attributes
      get :show, {:id => estimate.to_param}
      expect(assigns(:estimate)).to eq(estimate)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Estimate" do
        expect {
          post :create, {:estimate => valid_attributes}
        }.to change(Estimate, :count).by(1)
      end

      it "assigns a newly created estimate as @estimate" do
        post :create, {:estimate => valid_attributes}
        expect(assigns(:estimate)).to be_a(Estimate)
        expect(assigns(:estimate)).to be_persisted
      end

      it "returns 200 - ok" do
        post :create, {:estimate => valid_attributes}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved estimate as @estimate" do
        post :create, {:estimate => invalid_attributes}
        expect(assigns(:estimate)).to be_a_new(Estimate)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:estimate, date: Date.current.beginning_of_year + 10.days)
      }

      it "updates the requested estimate" do
        estimate = Estimate.create! valid_attributes
        put :update, {:id => estimate.to_param, :estimate => new_attributes}
        estimate.reload

        new_attributes.each do |key, value|
          expect(estimate[key]).to eq(value)
        end
      end

      it "assigns the requested estimate as @estimate" do
        estimate = Estimate.create! valid_attributes
        put :update, {:id => estimate.to_param, :estimate => valid_attributes}
        expect(assigns(:estimate)).to eq(estimate)
      end

      it "returns 200 - ok" do
        estimate = Estimate.create! valid_attributes
        put :update, {:id => estimate.to_param, :estimate => valid_attributes}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns the estimate as @estimate" do
        estimate = Estimate.create! valid_attributes
        put :update, {:id => estimate.to_param, :estimate => invalid_attributes}
        expect(assigns(:estimate)).to eq(estimate)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested estimate" do
      estimate = Estimate.create! valid_attributes
      expect {
        delete :destroy, {user_id: @user.id, :id => estimate.to_param}
      }.to change(Estimate, :count).by(-1)
    end

    it "returns 200 - ok" do
      estimate = Estimate.create! valid_attributes
      delete :destroy, {user_id: @user.id, :id => estimate.to_param}
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #invoice" do
    before(:each) do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    it "Warns when nothing to invoice" do
      estimate = create(:estimate)

      get :invoice, { user_id: @user, id: estimate }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('estimates.nothing_to_invoice'))
    end

    it "Generates invoice " do
      estimate = Estimate.create! valid_attributes

      get :invoice, { user_id: @user, id: estimate }

      estimate.reload

      estimate.estimate_details.each do |details|
        expect(details.invoice_detail_id).not_to be_nil

        expect(details.invoice_detail.description).to eq(details.description)
        expect(details.invoice_detail.quantity).to eq(details.quantity)
        expect(details.invoice_detail.service_id).to eq(details.service_id)
        expect(details.invoice_detail.vat_rate).to eq(details.invoice_detail.service.vat.rate)
        expect(details.invoice_detail.price).to eq(details.price)
      end

      expect(response).to have_http_status(:ok)
    end

    it  'Generates the invoice for spanish customers' do
      @user.update_attributes(country: 'ES', tax_id: '48299472R')

      estimate = Estimate.create! valid_attributes
      estimate.customer.update_attributes(irpf: 16)

      get :invoice, { user_id: @user, id: estimate }

      estimate.reload
      invoice = estimate.estimate_details.first.invoice_detail.invoice

      expect(invoice.irpf).to eq(16)
    end

    it "Fails when no paying method available" do
      PaymentMethod.delete_all

      estimate = Estimate.create! valid_attributes

      get :invoice, { user_id: @user, id: estimate }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('payment_methods.not_found'))
    end
  end
end
