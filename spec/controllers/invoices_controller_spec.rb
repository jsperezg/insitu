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

RSpec.describe InvoicesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Invoice. As you add validations to Invoice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    invoice = attributes_for(:invoice)

    invoice.merge(invoice_details_attributes: [ attributes_for(:invoice_detail, invoice_id: nil) ])
  }

  let(:invalid_attributes) {
    attributes_for(:invoice, date: nil)
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
    it "assigns all invoices as @invoices" do
      invoice = Invoice.create! valid_attributes
      get :index, {user_id: @user.id}

      expect(assigns(:invoices)).to eq([invoice])
    end
  end

  describe "GET #show" do
    it "assigns the requested invoice as @invoice" do
      invoice = Invoice.create! valid_attributes
      get :show, {:id => invoice.to_param, user_id: @user.id}
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe "GET #new" do
    it "assigns a new invoice as @invoice" do
      get :new, {user_id: @user.id}
      expect(assigns(:invoice)).to be_a_new(Invoice)
    end
  end

  describe "GET #edit" do
    it "assigns the requested invoice as @invoice" do
      invoice = Invoice.create! valid_attributes
      get :edit, {:id => invoice.to_param, user_id: @user.id}
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Invoice" do
        expect {
          post :create, {:invoice => valid_attributes, user_id: @user.id}
        }.to change(Invoice, :count).by(1)
      end

      it "assigns a newly created invoice as @invoice" do
        post :create, {:invoice => valid_attributes, user_id: @user.id}
        expect(assigns(:invoice)).to be_a(Invoice)
        expect(assigns(:invoice)).to be_persisted
      end

      it "redirects to the created invoice" do
        post :create, {:invoice => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(edit_user_invoice_url(@user, Invoice.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved invoice as @invoice" do
        post :create, {:invoice => invalid_attributes, user_id: @user.id}
        expect(assigns(:invoice)).to be_a_new(Invoice)
      end

      it "re-renders the 'new' template" do
        post :create, {:invoice => invalid_attributes, user_id: @user.id}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:invoice)
      }

      it "updates the requested invoice" do
        invoice = Invoice.create! valid_attributes
        put :update, {:id => invoice.to_param, :invoice => new_attributes, user_id: @user.id}
        invoice.reload

        new_attributes.each do |key, value|
          expect(invoice[key]).to eq(new_attributes[key])
        end
      end

      it "assigns the requested invoice as @invoice" do
        invoice = Invoice.create! valid_attributes
        put :update, {:id => invoice.to_param, :invoice => valid_attributes, user_id: @user.id}
        expect(assigns(:invoice)).to eq(invoice)
      end

      it "redirects to the invoice" do
        invoice = Invoice.create! valid_attributes
        put :update, {:id => invoice.to_param, :invoice => valid_attributes, user_id: @user.id}
        expect(response).to redirect_to(edit_user_invoice_url(@user, invoice))
      end
    end

    context "with invalid params" do
      it "assigns the invoice as @invoice" do
        invoice = Invoice.create! valid_attributes
        put :update, {:id => invoice.to_param, :invoice => invalid_attributes, user_id: @user.id}
        expect(assigns(:invoice)).to eq(invoice)
      end

      it "re-renders the 'edit' template" do
        invoice = Invoice.create! valid_attributes
        put :update, {:id => invoice.to_param, :invoice => invalid_attributes, user_id: @user.id}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested invoice" do
      invoice = Invoice.create! valid_attributes
      expect {
        delete :destroy, {:id => invoice.to_param, user_id: @user.id}
      }.to change(Invoice, :count).by(-1)
    end

    it "redirects to the invoices list" do
      invoice = Invoice.create! valid_attributes
      delete :destroy, {:id => invoice.to_param, user_id: @user.id}
      expect(response).to redirect_to(user_invoices_url(@user.id))
    end
  end
end
