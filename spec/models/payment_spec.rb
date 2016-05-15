require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'Validations' do
    describe 'txn_id' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :txn_id )}
      end

      it 'max length: 19' do
        payment = Payment.new(txn_id: (0...20).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :txn_id )}
      end
    end

    describe 'business' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :business )}
      end

      it 'max length: 127' do
        payment = Payment.new(business: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :business )}
      end
    end

    describe 'receiver_email' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :receiver_email )}
      end

      it 'max length: 127' do
        payment = Payment.new(receiver_email: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :receiver_email )}
      end

      it 'Valid value must be defined' do
        payment = Payment.new(receiver_email: (0...127).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :receiver_email )}

        expect(Rails.configuration.x.paypal_receiver_email).not_to satisfy { |expected_receiver_email| expected_receiver_email.blank? }
        payment = Payment.new(receiver_email: Rails.configuration.x.paypal_receiver_email)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| not errors.key?( :receiver_email )}
      end
    end

    describe 'receiver_id' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :receiver_id )}
      end

      it 'max length: 13' do
        payment = Payment.new(receiver_id: (0...14).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :receiver_id )}
      end
    end

    describe 'residence_country' do
      it 'max length: 2' do
        payment = Payment.new(residence_country: (0...3).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :residence_country )}
      end
    end

    it 'user_id is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :user_id )}
    end

    describe 'payer_id' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_id )}
      end

      it 'max length: 13' do
        payment = Payment.new(payer_id: (0...14).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_id )}
      end
    end

    describe 'payer_email' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_email )}
      end

      it 'max length: 127' do
        payment = Payment.new(payer_email: (0...128).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_email )}
      end
    end

    describe 'payer_status' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_status )}
      end

      it 'max length: 10' do
        payment = Payment.new(payer_email: (0...11).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payer_status )}
      end
    end

    it 'last_name max length: 64' do
      payment = Payment.new(last_name: (0...65).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :last_name )}
    end

    it 'first_name max length: 64' do
      payment = Payment.new(first_name: (0...65).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :first_name )}
    end

    it 'payment_date is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :payment_date )}
    end

    it 'payment_status is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :payment_status )}
    end

    describe 'payment_type' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payment_type )}
      end

      it 'max length: 7' do
        payment = Payment.new(payer_email: (0...8).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :payment_type )}
      end
    end

    describe 'txn_type' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :txn_type )}
      end

      it 'max length: 50' do
        payment = Payment.new(txn_type: (0...51).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :txn_type )}
      end
    end

    describe 'mc_gross' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :mc_gross )}
      end

      it 'is valid with regards to plan data' do
        plan = create(:plan, price: 5, months: 1)
        payment = Payment.new(plan_id: plan.id, mc_gross: 1)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :mc_gross )}

        payment = Payment.new(plan_id: plan.id, mc_gross: plan.price * (1 + plan.vat_rate / 100.0))
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| not errors.key?( :mc_gross )}
      end
    end

    it 'tax is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :tax )}
    end

    it 'mc_fee is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :mc_fee )}
    end

    describe 'quantity' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :quantity )}
      end

      it 'must be a positive number' do
        payment = Payment.new(quantity: 0)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :quantity )}
      end

      it 'must be an integer' do
        payment = Payment.new(quantity: 0.12)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :quantity )}
      end
    end

    it 'plan_id is mandatory' do
      payment = Payment.new
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :plan_id )}
    end

    describe 'mc_currency' do
      it 'is mandatory' do
        payment = Payment.new
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :mc_currency )}
      end

      it 'maximum length: 5' do
        payment = Payment.new(mc_currency: (0...6).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :mc_currency )}
      end

      it 'Only EUR accepted' do
        payment = Payment.new(mc_currency: (0...5).map { ('a'..'z').to_a[rand(26)] }.join)
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| errors.key?( :mc_currency )}

        payment = Payment.new(mc_currency: 'EUR')
        expect(payment.save).to be_falsey
        expect(payment.errors).to satisfy { |errors| not errors.key?( :mc_currency )}
      end
    end


    it 'notify_version accepts maximum 25 chars' do
      payment = Payment.new(notify_version: (0...26).map { ('a'..'z').to_a[rand(26)] }.join)
      expect(payment.save).to be_falsey
      expect(payment.errors).to satisfy { |errors| errors.key?( :notify_version )}
    end
  end
end
