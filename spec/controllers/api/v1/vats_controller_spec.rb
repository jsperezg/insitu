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

RSpec.describe Api::V1::VatsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Vat. As you add validations to Vat, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for :vat
  }

  let(:invalid_attributes) {
    vat = attributes_for :vat
    vat[:rate] = -1

    vat
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
    it "assigns all vats as @vats" do
      vat = Vat.create! valid_attributes
      get :index, { format: :json }
      expect(assigns(:vats)).to include(vat)
    end
  end

  describe "GET #show" do
    it "assigns the requested vat as @vat" do
      vat = Vat.create! valid_attributes
      get :show, {:id => vat.to_param, format: :json }
      expect(assigns(:vat)).to eq(vat)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Vat" do
        expect {
          post :create, {:vat => valid_attributes, format: :json }
        }.to change(Vat, :count).by(1)
      end

      it "assigns a newly created vat as @vat" do
        post :create, {:vat => valid_attributes, format: :json }
        expect(assigns(:vat)).to be_a(Vat)
        expect(assigns(:vat)).to be_persisted
      end

      it "returns 200 - ok" do
        post :create, { :vat => valid_attributes, format: :json}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved vat as @vat" do
        post :create, {:vat => invalid_attributes, format: :json }
        expect(assigns(:vat)).to be_a_new(Vat)
        expect(assigns(:vat)).not_to be_persisted
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { label: '16%', rate: 16 }
      }

      it "updates the requested vat" do
        vat = Vat.create! valid_attributes
        put :update, {:id => vat.to_param, :vat => new_attributes, format: :json }
        vat.reload

        expect(vat[:label]).to eq(new_attributes[:label])
        expect(vat[:rate]).to eq(new_attributes[:rate])
      end

      it "assigns the requested vat as @vat" do
        vat = Vat.create! valid_attributes
        put :update, {:id => vat.to_param, :vat => valid_attributes, response: :json }
        expect(assigns(:vat)).to eq(vat)
      end

      it "returns 200 - ok" do
        vat = Vat.create! valid_attributes
        put :update, {:id => vat.to_param, :vat => valid_attributes, response: :json }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "assigns the vat as @vat" do
        vat = Vat.create! valid_attributes
        put :update, {:id => vat.to_param, :vat => invalid_attributes, response: :json }
        expect(assigns(:vat)).to eq(vat)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested vat" do
      vat = Vat.create! valid_attributes
      expect {
        delete :destroy, {:id => vat.to_param, response: :json }
      }.to change(Vat, :count).by(-1)
    end

    it "returns 200 - ok" do
      vat = Vat.create! valid_attributes
      delete :destroy, {:id => vat.to_param, response: :json }
      expect(response).to have_http_status(:ok)
    end
  end

end
