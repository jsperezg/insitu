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

RSpec.describe Api::V1::UnitsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Unit. As you add validations to Unit, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    @label_sequence = 0 if @label_sequence.nil?
    @label_sequence += 1

    { label_short: "U#{@label_sequence}", label_long: "Unit #{@label_sequence}" }
  }

  let(:invalid_attributes) {
    { label_short: nil, label_long: 'Label long' }
  }

  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user
  end

  after(:each) do
    sign_out @user
  end

  describe 'GET #index' do
    it 'assigns all units as @units' do
      unit = Unit.create! valid_attributes
      get :index, params: { format: :json }
      expect(assigns(:units)).to include(unit)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested unit as @unit' do
      unit = Unit.create! valid_attributes
      get :show, params: { id: unit.to_param, format: :json }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Unit' do
        expect {
          post :create, params: { unit: valid_attributes, format: :json }
        }.to change(Unit, :count).by(1)
      end

      it 'assigns a newly created unit as @unit' do
        post :create, params: { unit: valid_attributes, format: :json }
        expect(assigns(:unit)).to be_a(Unit)
        expect(assigns(:unit)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { unit: valid_attributes, format: :json }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved unit as @unit' do
        post :create, params: { unit: invalid_attributes, format: :json }
        expect(assigns(:unit)).to be_a_new(Unit)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { label_short: 'updated label short', label_long: 'updated label long' }
      }

      it 'updates the requested unit' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: new_attributes, format: :json }
        unit.reload

        expect(unit[:label_short]).to eq(new_attributes[:label_short])
        expect(unit[:label_long]).to eq(new_attributes[:label_long])
      end

      it 'assigns the requested unit as @unit' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: valid_attributes, format: :json }
        expect(assigns(:unit)).to eq(unit)
      end

      it 'returns 200 - ok' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: valid_attributes, format: :json }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the unit as @unit' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: invalid_attributes, format: :json }
        expect(assigns(:unit)).to eq(unit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested unit' do
      unit = Unit.create! valid_attributes
      expect {
        delete :destroy, params: { id: unit.to_param, format: :json }
      }.to change(Unit, :count).by(-1)
    end

    it 'returns 200 - ok' do
      unit = Unit.create! valid_attributes
      delete :destroy, params: { id: unit.to_param, format: :json }
      expect(response).to have_http_status(:ok)
    end
  end
end
