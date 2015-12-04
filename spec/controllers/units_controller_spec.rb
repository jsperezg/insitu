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

RSpec.describe UnitsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Unit. As you add validations to Unit, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for :unit
  }

  let(:invalid_attributes) {
    unit = attributes_for :unit

    unit[:label_short] = nil

    unit
  }

  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  after(:each) do
    sign_out @user
  end

  describe "GET #index" do
    it "assigns all units as @units" do
      unit = Unit.create! valid_attributes
      get :index, { user_id: @user.id }
      expect(assigns(:units)).to include(unit)
    end
  end

  describe "GET #show" do
    it "assigns the requested unit as @unit" do
      unit = Unit.create! valid_attributes
      get :show, { :id => unit.to_param, user_id: @user.id }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe "GET #new" do
    it "assigns a new unit as @unit" do
      get :new, { user_id: @user.id }
      expect(assigns(:unit)).to be_a_new(Unit)
    end
  end

  describe "GET #edit" do
    it "assigns the requested unit as @unit" do
      unit = Unit.create! valid_attributes
      get :edit, {:id => unit.to_param, user_id: @user.id }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Unit" do
        expect {
          post :create, {:unit => valid_attributes, user_id: @user.id }
        }.to change(Unit, :count).by(1)
      end

      it "assigns a newly created unit as @unit" do
        post :create, {:unit => valid_attributes, user_id: @user.id}
        expect(assigns(:unit)).to be_a(Unit)
        expect(assigns(:unit)).to be_persisted
      end

      it "redirects to the created unit" do
        post :create, {:unit => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(user_units_path(@user.id))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved unit as @unit" do
        post :create, {:unit => invalid_attributes, user_id: @user.id}
        expect(assigns(:unit)).to be_a_new(Unit)
      end

      it "re-renders the 'new' template" do
        post :create, {:unit => invalid_attributes,user_id: @user.id}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { label_short: 'updated label short', label_long: 'updated label long' }
      }

      it "updates the requested unit" do
        unit = Unit.create! valid_attributes
        put :update, {:id => unit.to_param, :unit => new_attributes, user_id: @user.id}
        unit.reload
        
        expect(unit[:label_short]).to eq(new_attributes[:label_short])
        expect(unit[:label_long]).to eq(new_attributes[:label_long])
      end

      it "assigns the requested unit as @unit" do
        unit = Unit.create! valid_attributes
        put :update, {:id => unit.to_param, :unit => valid_attributes, user_id: @user.id}
        expect(assigns(:unit)).to eq(unit)
      end

      it "redirects to the unit" do
        unit = Unit.create! valid_attributes
        put :update, {:id => unit.to_param, :unit => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(user_units_path(@user.id))
      end
    end

    context "with invalid params" do
      it "assigns the unit as @unit" do
        unit = Unit.create! valid_attributes
        put :update, {:id => unit.to_param, :unit => invalid_attributes, user_id: @user.id}
        expect(assigns(:unit)).to eq(unit)
      end

      it "re-renders the 'edit' template" do
        unit = Unit.create! valid_attributes
        put :update, {:id => unit.to_param, :unit => invalid_attributes, user_id: @user.id}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested unit" do
      unit = Unit.create! valid_attributes
      expect {
        delete :destroy, {:id => unit.to_param, user_id: @user.id}
      }.to change(Unit, :count).by(-1)
    end

    it "redirects to the units list" do
      unit = Unit.create! valid_attributes
      delete :destroy, {:id => unit.to_param, user_id: @user.id}
      expect(response).to redirect_to(user_units_url(@user.id))
    end
  end

end
