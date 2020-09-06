# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliveryNotesController, type: :controller do
  let(:valid_attributes) do
    {
      customer_id: create(:customer).id,
      date: Time.now,
      delivery_note_details_attributes: [attributes_for(:delivery_note_detail, delivery_note_id: nil)]
    }
  end

  let(:invalid_attributes) do
    { customer_id: nil, date: nil }
  end

  let(:user) { User.first || create(:user) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all delivery_notes as @delivery_notes' do
      delivery_note = create(:delivery_note)
      get :index, params: { user_id: user.id }
      expect(assigns(:delivery_notes)).to eq([delivery_note])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested delivery_note as @delivery_note' do
      delivery_note = create(:delivery_note)
      get :show, params: { id: delivery_note.to_param, user_id: user.id }
      expect(assigns(:delivery_note)).to eq(delivery_note)
    end
  end

  describe 'GET #new' do
    it 'assigns a new delivery_note as @delivery_note' do
      get :new, params: { user_id: user.id }
      expect(assigns(:delivery_note)).to be_a_new(DeliveryNote)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested delivery_note as @delivery_note' do
      delivery_note = DeliveryNote.create! valid_attributes
      get :edit, params: { id: delivery_note.to_param, user_id: user.id }
      expect(assigns(:delivery_note)).to eq(delivery_note)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DeliveryNote' do
        expect do
          post :create, params: { delivery_note: valid_attributes, user_id: user.id }
        end.to change(DeliveryNote, :count).by(1)
      end

      it 'assigns a newly created delivery_note as @delivery_note' do
        post :create, params: { delivery_note: valid_attributes, user_id: user.id }
        expect(assigns(:delivery_note)).to be_a(DeliveryNote)
        expect(assigns(:delivery_note)).to be_persisted
      end

      it 'redirects to the created delivery_note' do
        post :create, params: { delivery_note: valid_attributes, user_id: user.id }
        expect(response).to redirect_to(edit_user_delivery_note_path(user, DeliveryNote.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved delivery_note as @delivery_note' do
        post :create, params: { delivery_note: invalid_attributes, user_id: user.id }
        expect(assigns(:delivery_note)).to be_a_new(DeliveryNote)
      end

      it "re-renders the 'new' template" do
        post :create, params: { delivery_note: invalid_attributes, user_id: user.id }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        new_date = Time.now.utc.beginning_of_day - 7.days

        attributes_for :delivery_note, date: new_date, number: "T/#{new_date.year}/999999"
      end

      it 'updates the requested delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: new_attributes, user_id: user.id }
        delivery_note.reload

        expect(delivery_note.date.strftime('%Y-%m-%d')).to eq((Time.now.utc.beginning_of_day - 7.days).strftime('%Y-%m-%d'))
      end

      it 'assigns the requested delivery_note as @delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: valid_attributes, user_id: user.id }
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end

      it 'redirects to the delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: valid_attributes, user_id: user.id }
        expect(response).to redirect_to(edit_user_delivery_note_path(user, DeliveryNote.last))
      end
    end

    context 'with invalid params' do
      it 'assigns the delivery_note as @delivery_note' do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: invalid_attributes, user_id: user.id }
        expect(assigns(:delivery_note)).to eq(delivery_note)
      end

      it "re-renders the 'edit' template" do
        delivery_note = DeliveryNote.create! valid_attributes
        put :update, params: { id: delivery_note.to_param, delivery_note: invalid_attributes, user_id: user.id }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested delivery_note' do
      delivery_note = DeliveryNote.create! valid_attributes
      expect do
        delete :destroy, params: { id: delivery_note.to_param, user_id: user.id }
      end.to change(DeliveryNote, :count).by(-1)
    end

    it 'redirects to the delivery_notes list' do
      delivery_note = DeliveryNote.create! valid_attributes
      delete :destroy, params: { id: delivery_note.to_param, user_id: user.id }
      expect(response).to redirect_to(user_delivery_notes_url(user))
    end
  end

  describe 'GET #invoice' do
    before do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    it 'Warns when nothing to invoice' do
      delivery_note = create(:delivery_note)

      get :invoice, params: { user_id: user, id: delivery_note }
      expect(response).to redirect_to(user_delivery_notes_path(user))
      expect(flash[:alert]).to eq(I18n.t('delivery_notes.nothing_to_invoice'))
    end

    it 'Generates invoice' do
      delivery_note = DeliveryNote.create! valid_attributes

      get :invoice, params: { user_id: user, id: delivery_note }

      delivery_note.reload

      delivery_note.delivery_note_details.each do |details|
        expect(details.invoice_detail_id).not_to be_nil

        expect(details.invoice_detail.description).to eq(details.description)
        expect(details.invoice_detail.quantity).to eq(details.quantity)
        expect(details.invoice_detail.service_id).to eq(details.service_id)
        expect(details.invoice_detail.vat_rate).to eq(details.invoice_detail.service.vat.rate)
        expect(details.invoice_detail.price).to eq(details.price)

        expect(response).to redirect_to(edit_user_invoice_path(user, details.invoice_detail.invoice_id))
      end
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

      delivery_note = DeliveryNote.create! valid_attributes

      get :invoice, params: { user_id: user, id: delivery_note }

      expect(response).to redirect_to user_delivery_notes_path(user.id)
      expect(flash[:alert]).to eq(I18n.t('payment_methods.not_found'))
    end
  end

  describe 'GET #forward_email' do
    let(:customer_without_email_delivery_note) do
      customer = create(:customer, contact_email: nil)
      delivery_note = attributes_for :delivery_note, customer_id: customer.id
      delivery_note.merge(delivery_note_details_attributes: [attributes_for(:delivery_note_detail, delivery_note_id: nil)])

      delivery_note
    end

    it 'fails for customers without email' do
      delivery_note = DeliveryNote.create! customer_without_email_delivery_note

      get :forward_email, params: { user_id: user, id: delivery_note }

      expect(response).to redirect_to(user_delivery_note_path(user.id, delivery_note.id))
      expect(flash[:error]).to eq(I18n.t('helpers.customer_mail_missing'))
    end
  end
end
