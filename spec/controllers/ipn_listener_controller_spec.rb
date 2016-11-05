require 'rails_helper'

RSpec.describe IpnListenerController, type: :controller do
  describe "POST #create" do
    context "VERIFIED response" do
      before(:each) do
        allow_any_instance_of(IpnListenerController).to receive(:validate_ipn_notification).and_return('VERIFIED')
      end

      it 'returns OK response code' do
        post :create
        expect(response).to have_http_status(:ok)
      end

      it 'referred subscription is renewed' do
        user = create(:expired_user)

        post :create, paypal_renewal_request(user)

        user.reload
        expect(user.is_premium?).to be_truthy
      end

      it 'payment is created' do
        user = create(:expired_user)

        post :create, paypal_renewal_request(user)

        payment = Payment.find_by(user_id: user.id)
        expect(payment).not_to be_nil
      end

      it 'Invoicing task is invoked' do
        user = create(:expired_user)

        expect(RenewSubscriptionJob).to receive(:perform_now)
        post :create, paypal_renewal_request(user)
      end
    end

    context "INVALID response" do
      before(:each) do
        allow_any_instance_of(IpnListenerController).to receive(:validate_ipn_notification).and_return('INVALID')
      end

      it 'returns OK response code' do
        post :create
        expect(response).to have_http_status(:ok)
      end

      it 'referred subscription remains unchanged' do
        user = create(:expired_user)

        post :create, paypal_renewal_request(user)

        user.reload
        expect(user.is_premium?).to be_falsey
      end
    end

    context "Other responses" do
      before(:each) do
        allow_any_instance_of(IpnListenerController).to receive(:validate_ipn_notification).and_return('WTF')
      end

      it 'returns unprocessable entity response code' do
        post :create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
