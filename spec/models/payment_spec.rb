# frozen_string_literal: true

require 'rails_helper'

describe Payment, type: :model do
  describe 'Validations' do
    describe 'txn_id' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :txn_id
      end

      it 'max length: 19' do
        payment = described_class.create(txn_id: (0...20).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :txn_id
      end
    end

    describe 'business' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :business
      end

      it 'max length: 127' do
        payment = described_class.create(business: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :business
      end
    end

    describe 'receiver_email' do
      it 'is mandatory' do
        payment = described_class.create
        payment.save
        expect(payment.errors).to be_key :receiver_email
      end

      it 'max length: 127' do
        payment = described_class.create(receiver_email: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        payment.save
        expect(payment.errors).to be_key :receiver_email
      end

      it 'Valid value must be defined' do
        payment = described_class.create(receiver_email: (0...127).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :receiver_email

        Rails.configuration.x.paypal_receiver_email = Faker::Internet.email
        payment = described_class.create(receiver_email: Rails.configuration.x.paypal_receiver_email)
        expect(payment.errors).not_to be_key :receiver_email
      end
    end

    describe 'receiver_id' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :receiver_id
      end

      it 'max length: 13' do
        payment = described_class.create(receiver_id: (0...14).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :receiver_id
      end
    end

    describe 'residence_country' do
      it 'max length: 2' do
        payment = described_class.create(residence_country: (0...3).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :residence_country
      end
    end

    it 'user_id is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :user_id
    end

    describe 'payer_id' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :payer_id
      end

      it 'max length: 13' do
        payment = described_class.create(payer_id: (0...14).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :payer_id
      end
    end

    describe 'payer_email' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.save).to be_falsey
        expect(payment.errors).to be_key :payer_email
      end

      it 'max length: 127' do
        payment = described_class.create(payer_email: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :payer_email
      end
    end

    describe 'payer_status' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :payer_status
      end

      it 'max length: 10' do
        payment = described_class.create(payer_email: (0...11).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :payer_status
      end
    end

    it 'last_name max length: 64' do
      payment = described_class.create(last_name: (0...65).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.errors).to be_key :last_name
    end

    it 'first_name max length: 64' do
      payment = described_class.create(first_name: (0...65).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.errors).to be_key :first_name
    end

    it 'payment_date is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :payment_date
    end

    it 'payment_status is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :payment_status
    end

    describe 'payment_type' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :payment_type
      end

      it 'max length: 7' do
        payment = described_class.create(payer_email: (0...8).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :payment_type
      end
    end

    describe 'txn_type' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :txn_type
      end

      it 'max length: 50' do
        payment = described_class.create(txn_type: (0...51).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :txn_type
      end
    end

    describe 'mc_gross' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :mc_gross
      end

      it 'is valid with regards to plan data' do
        plan = create(:plan, price: 5, months: 1)
        payment = described_class.create(plan_id: plan.id, mc_gross: 1)
        expect(payment.errors).to be_key :mc_gross

        payment = described_class.create(plan_id: plan.id, mc_gross: plan.price * (1 + plan.vat_rate / 100.0))
        expect(payment.save).to be_falsey
        expect(payment.errors).not_to be_key :mc_gross
      end
    end

    it 'tax is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :tax
    end

    it 'mc_fee is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :mc_fee
    end

    describe 'quantity' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :quantity
      end

      it 'must be a positive number' do
        payment = described_class.create(quantity: 0)
        expect(payment.errors).to be_key :quantity
      end

      it 'must be an integer' do
        payment = described_class.create(quantity: 0.12)
        expect(payment.errors).to be_key :quantity
      end
    end

    it 'plan_id is mandatory' do
      payment = described_class.create
      expect(payment.errors).to be_key :plan_id
    end

    describe 'mc_currency' do
      it 'is mandatory' do
        payment = described_class.create
        expect(payment.errors).to be_key :mc_currency
      end

      it 'maximum length: 5' do
        payment = described_class.create(mc_currency: (0...6).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :mc_currency
      end

      it 'Only EUR accepted' do
        payment = described_class.create(mc_currency: (0...5).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.errors).to be_key :mc_currency

        payment = described_class.create(mc_currency: 'EUR')
        expect(payment.errors).not_to be_key :mc_currency
      end
    end

    it 'notify_version accepts maximum 25 chars' do
      payment = described_class.create(notify_version: (0...26).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.errors).to be_key :notify_version
    end
  end
end
