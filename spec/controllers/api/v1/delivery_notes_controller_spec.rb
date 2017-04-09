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

RSpec.describe Api::V1::DeliveryNotesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DeliveryNote. As you add validations to DeliveryNote, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    delivery_note = attributes_for :delivery_note
    delivery_note.merge(delivery_note_details_attributes: [ attributes_for(:delivery_note_detail, delivery_note_id: nil) ])

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

  describe 'GET #index' do
    it 'assigns all delivery_notes as @delivery_notes' do
      delivery_note = DeliveryNote.create! valid_attributes
      get :index
      expect(assigns(:delivery_notes)).to eq([delivery_note])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested delivery_note as @delivery_note' do
      delivery_note = DeliveryNote.create! valid_attributes
      get :show, params: { id: delivery_note.to_param }
      expect(assigns(:delivery_note)).to eq(delivery_note)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DeliveryNote' do
        expect {
          post :create, params: { delivery_note: valid_attributes}
        }.to change(DeliveryNote, :count).by(1)
      end

      it 'assigns a newly created delivery_note as @delivery_note' do
        post :create, params: { delivery_note: valid_attributes}
        expect(assigns(:delivery_note)).to be_a(DeliveryNote)
        expect(assigns(:delivery_note)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { delivery_note: valid_attributes, user_id: @user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved delivery_note as @delivery_note' do
        post :create, params:  { delivery_note: invalid_attributes }
        expect(assigns(:delivery_note)).to be_a_new(DeliveryNote)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        new_date = DateTime.now.utc.beginning_of_day - 7.days

        attributes_for :delivery_note, date: new_date, number: "T/#{new_date.year}/999999"
      }

      it 'updates the requested delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: new_attributes}
        delivery_note.reload

        expect(delivery_note.date.strftime('%Y-%m-%d')).to eq((DateTime.now.utc.beginning_of_day - 7.days).strftime('%Y-%m-%d'))
      end

      it 'assigns the requested delivery_note as @delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: valid_attributes }
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end

      it 'Returns HTTP 200' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: valid_attributes, user_id: @user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the delivery_note as @delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: invalid_attributes }
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested delivery_note' do
      delivery_note = DeliveryNote.create! valid_attributes
      expect {
        delete :destroy, params: { id: delivery_note.to_param, user_id: @user.id}
      }.to change(DeliveryNote, :count).by(-1)
    end

    it 'Returns 200' do
      delivery_note = DeliveryNote.create! valid_attributes
      delete :destroy, params: { id: delivery_note.to_param, user_id: @user.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #invoice' do
    before(:each) do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    it 'Warns when nothing to invoice' do
      delivery_note = create(:delivery_note)

      get :invoice, params: { user_id: @user, id: delivery_note }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('delivery_notes.nothing_to_invoice'))
    end

    it 'Generates invoice' do
      delivery_note = DeliveryNote.create! valid_attributes

      get :invoice, params: { user_id: @user, id: delivery_note }

      delivery_note.reload

      delivery_note.delivery_note_details.each do |details|
        expect(details.invoice_detail_id).not_to be_nil

        expect(details.invoice_detail.description).to eq(details.description)
        expect(details.invoice_detail.quantity).to eq(details.quantity)
        expect(details.invoice_detail.service_id).to eq(details.service_id)
        expect(details.invoice_detail.vat_rate).to eq(details.invoice_detail.service.vat.rate)
        expect(details.invoice_detail.price).to eq(details.price)

        expect(response).to redirect_to(edit_user_invoice_path(@user, details.invoice_detail.invoice_id))
      end
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

      delivery_note = DeliveryNote.create! valid_attributes

      get :invoice, params: { user_id: @user, id: delivery_note }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('payment_methods.not_found'))
    end
  end
end
