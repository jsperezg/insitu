# frozen_string_literal: true

FactoryGirl.define do
  factory :payment do
    txn_id '9GR92966H7651493J'
    business { Rails.configuration.x.paypal_receiver_email }
    receiver_email { Rails.configuration.x.paypal_receiver_email }
    receiver_id 'RYG2VVDDN76XA'
    residence_country 'ES'
    user_id { create(:user, :expired)&.id }
    payer_id 'RYG2VVDDN76XA'
    payer_email { Faker::Internet.free_email }
    payer_status 'verified'
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    payment_date { DateTime.now }
    payment_status 'Completed'
    payment_type 'instant'
    txn_type 'web_accept'
    mc_gross { (Plan.first || create(:plan)).price * 1.21 }
    tax { (Plan.first || create(:plan)).price * 0.21 }
    mc_fee 0.56
    quantity 1
    plan_id { Plan.first.try(:id) || create(:plan).try(:id) }
    mc_currency 'EUR'
    notify_version '3.8'
  end
end
