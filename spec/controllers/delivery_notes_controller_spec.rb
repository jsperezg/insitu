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

RSpec.describe DeliveryNotesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DeliveryNote. As you add validations to DeliveryNote, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    delivery_note = attributes_for :delivery_note
    delivery_note.merge(delivery_note_details_attributes: [ attributes_for(:delivery_note_detail) ])

    delivery_note
  }

  let(:invalid_attributes) {
    { customer_id: nil, date: nil }
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
    it "assigns all delivery_notes as @delivery_notes" do
      delivery_note = DeliveryNote.create! valid_attributes
      get :index, { user_id: @user.id }
      expect(assigns(:delivery_notes)).to eq([delivery_note])
    end
  end

  describe "GET #show" do
    it "assigns the requested delivery_note as @delivery_note" do
      delivery_note = DeliveryNote.create! valid_attributes
      get :show, { :id => delivery_note.to_param, user_id: @user.id }
      expect(assigns(:delivery_note)).to eq(delivery_note)
    end
  end

  describe "GET #new" do
    it "assigns a new delivery_note as @delivery_note" do
      get :new, { user_id: @user.id }
      expect(assigns(:delivery_note)).to be_a_new(DeliveryNote)
    end
  end

  describe "GET #edit" do
    it "assigns the requested delivery_note as @delivery_note" do
      delivery_note = DeliveryNote.create! valid_attributes
      get :edit, {:id => delivery_note.to_param, user_id: @user.id }
      expect(assigns(:delivery_note)).to eq(delivery_note)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DeliveryNote" do
        expect {
          post :create, {:delivery_note => valid_attributes, user_id: @user.id}
        }.to change(DeliveryNote, :count).by(1)
      end

      it "assigns a newly created delivery_note as @delivery_note" do
        post :create, {:delivery_note => valid_attributes, user_id: @user.id}
        expect(assigns(:delivery_note)).to be_a(DeliveryNote)
        expect(assigns(:delivery_note)).to be_persisted
      end

      it "redirects to the created delivery_note" do
        post :create, {:delivery_note => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(edit_user_delivery_note_path(@user, DeliveryNote.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved delivery_note as @delivery_note" do
        post :create, {:delivery_note => invalid_attributes, user_id: @user.id }
        expect(assigns(:delivery_note)).to be_a_new(DeliveryNote)
      end

      it "re-renders the 'new' template" do
        post :create, {:delivery_note => invalid_attributes, user_id: @user.id}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        delivery_note = attributes_for :delivery_note
        delivery_note[:date] = DateTime.now.utc.beginning_of_day - 7.days

        delivery_note
      }

      it "updates the requested delivery_note" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, {:id => delivery_note.to_param, :delivery_note => new_attributes, user_id: @user.id}
        delivery_note.reload        

        expect(delivery_note.date.strftime('%Y-%m-%d')).to eq((DateTime.now.utc.beginning_of_day - 7.days).strftime('%Y-%m-%d'))
      end

      it "assigns the requested delivery_note as @delivery_note" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, {:id => delivery_note.to_param, :delivery_note => valid_attributes, user_id: @user.id}
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end

      it "redirects to the delivery_note" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, {:id => delivery_note.to_param, :delivery_note => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(edit_user_delivery_note_path(@user, DeliveryNote.last))
      end
    end

    context "with invalid params" do
      it "assigns the delivery_note as @delivery_note" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, {:id => delivery_note.to_param, :delivery_note => invalid_attributes, user_id: @user.id}
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end

      it "re-renders the 'edit' template" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, {:id => delivery_note.to_param, :delivery_note => invalid_attributes, user_id: @user.id}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested delivery_note" do
      delivery_note = DeliveryNote.create! valid_attributes
      expect {
        delete :destroy, {:id => delivery_note.to_param, user_id: @user.id}
      }.to change(DeliveryNote, :count).by(-1)
    end

    it "redirects to the delivery_notes list" do
      delivery_note = DeliveryNote.create! valid_attributes
      delete :destroy, {:id => delivery_note.to_param, user_id: @user.id}
      expect(response).to redirect_to(user_delivery_notes_url(@user))
    end
  end
end
