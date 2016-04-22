require 'rails_helper'

RSpec.describe EstimateDetail, type: :model do
  it "service_id is mandatory" do
		estimate_detail = EstimateDetail.new
		estimate_detail.save

		expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :service_id )}
	end

	describe "quantity" do
		it "is mandatory" do
			estimate_detail = EstimateDetail.new
  		estimate_detail.save

  		expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
  	end

		it "must be a number" do
			estimate_detail = EstimateDetail.new(quantity: 'asdf')
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end

		it "is greater than zero" do
			estimate_detail = EstimateDetail.new(quantity: 0)
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end
	end

	describe "price" do
		it "is mandatory" do
			estimate_detail = EstimateDetail.new
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "must be a number" do
			estimate_detail = EstimateDetail.new(price: 'asdf')
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "is greater than zero" do
			estimate_detail = EstimateDetail.new(price: 0)
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end
	end

  describe "discount" do
		it "is zero by default" do
			estimate_detail = EstimateDetail.new
  		estimate_detail.save

  		expect(estimate_detail.discount).to equal (0)
  	end

		it "must be a number" do
			estimate_detail = EstimateDetail.new(discount: 'asdf')
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :discount )}
		end

		it "is greater or equal to zero" do
			estimate_detail = EstimateDetail.new(discount: -1)
			estimate_detail.save

			expect(estimate_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :discount )}
		end
	end

	it "total is quatity x price" do
		delivery_note_detail = EstimateDetail.new(quantity: 10.0, price: 18.0, discount: 0)
		expect(delivery_note_detail.total).to eq(180.0)
  end

	it 'expired user cant save delivery notes' do
		Thread.current[:user] = create(:expired_user)
		object = EstimateDetail.new
		object.save

		expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
		expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
	end
end
