require 'rails_helper'

RSpec.describe InvoiceDetail, type: :model do
  it "service_id is mandatory" do
		invoice_detail = InvoiceDetail.new
		invoice_detail.save

		expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :service_id )}
	end

  	describe "quantity" do
  		it "is mandatory" do
  			invoice_detail = InvoiceDetail.new
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end

		it "must be a number" do
  			invoice_detail = InvoiceDetail.new(quantity: 'asdf')
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end

		it "is greater than zero" do
  			invoice_detail = InvoiceDetail.new(quantity: 0)
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end
	end

	describe "price" do
  		it "is mandatory" do
  			invoice_detail = InvoiceDetail.new
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "must be a number" do
  			invoice_detail = InvoiceDetail.new(price: 'asdf')
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "is greater than zero" do
  			invoice_detail = InvoiceDetail.new(price: -1)
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end
	end

	describe 'vat rate' do
		it "is mandatory" do
  			invoice_detail = InvoiceDetail.new
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :vat_rate )}
		end

		it "must be a number" do
  			invoice_detail = InvoiceDetail.new(vat_rate: 'asdf')
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :vat_rate )}
		end

		it "is greater or equal to zero" do
  			invoice_detail = InvoiceDetail.new(vat_rate: -1)
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :vat_rate )}
		end

		it 'is a integer number' do
			invoice_detail = InvoiceDetail.new(vat_rate: 1.1)
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :vat_rate )}
		end
	end

	describe "discount" do
  		it "is mandatory" do
  			invoice_detail = InvoiceDetail.new
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :discount )}
		end

		it "must be a number" do
  			invoice_detail = InvoiceDetail.new(discount: 'asdf')
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :discount )}
		end

		it "is greater or equal to zero" do
  			invoice_detail = InvoiceDetail.new(discount: -1)
			invoice_detail.save

			expect(invoice_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :discount )}
		end
	end
end
