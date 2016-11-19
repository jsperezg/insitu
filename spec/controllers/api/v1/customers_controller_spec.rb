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

RSpec.describe Api::V1::CustomersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for :customer
  }

  let(:invalid_attributes) {
    { name: '' }
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
    it "assigns all customers as @customers" do
      customer = Customer.create! valid_attributes
      get :index, {user_id: @user.id, format: :json }
      expect(assigns(:customers)).to eq([customer])
    end
  end

  describe "GET #show" do
    it "assigns the requested customer as @customer" do
      customer = Customer.create! valid_attributes
      get :show, {user_id: @user.id, :id => customer.to_param, format: :json }
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Customer" do
        expect {
          post :create, {user_id: @user.id, :customer => valid_attributes, format: :json}
        }.to change(Customer, :count).by(1)
      end

      it "assigns a newly created customer as @customer" do
        post :create, {user_id: @user.id, :customer => valid_attributes, format: :json}
        expect(assigns(:customer)).to be_a(Customer)
        expect(assigns(:customer)).to be_persisted
      end

      it "returns 200 - ok" do
        post :create, { user_id: @user.id, :customer => valid_attributes, format: :json}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved customer as @customer" do
        post :create, {user_id: @user.id, :customer => invalid_attributes, format: :json}
        expect(assigns(:customer)).to be_a_new(Customer)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for :customer
      }

      it "updates the requested customer" do
        customer = Customer.create! valid_attributes
        put :update, {user_id: @user.id, :id => customer.to_param, :customer => new_attributes, format: :json }
        customer.reload

        new_attributes.each do |key, value|
          expect(customer[key]).to eq(value)
        end
      end

      it "assigns the requested customer as @customer" do
        customer = Customer.create! valid_attributes
        put :update, {user_id: @user.id, :id => customer.to_param, :customer => valid_attributes, format: :json }
        expect(assigns(:customer)).to eq(customer)
      end

      it "returns 200 - ok" do
        customer = Customer.create! valid_attributes
        put :update, {user_id: @user.id, :id => customer.to_param, :customer => valid_attributes, format: :json }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns the customer as @customer" do
        customer = Customer.create! valid_attributes
        put :update, {user_id: @user.id, :id => customer.to_param, :customer => invalid_attributes, format: :json }
        expect(assigns(:customer)).to eq(customer)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested customer" do
      customer = Customer.create! valid_attributes
      expect {
        delete :destroy, {user_id: @user.id, :id => customer.to_param, format: :json }
      }.to change(Customer, :count).by(-1)
    end

    it "returns 200 - ok" do
      customer = Customer.create! valid_attributes
      delete :destroy, {user_id: @user.id, :id => customer.to_param, format: :json}
      expect(response).to have_http_status(:ok)
    end
  end

end
