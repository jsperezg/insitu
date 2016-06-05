require 'rails_helper'

RSpec.describe "customers/new", type: :view do
  describe 'generic validations' do
    before(:each) do
      @user = create(:user)
      sign_in @user

      assign(:customer, Customer.new)
    end

    after(:each) do
      sign_out @user
    end

    it "Renders a form tag" do
      render

      assert_select "form[action=?][method=?]", user_customers_path(@user.id), "post"
    end
  end

  describe 'spanish freelancer' do
    before(:each) do
      @user = create(:user, country: 'ES', tax_id: '00000000L')
      sign_in @user

      assign(:customer, Customer.new)
    end

    after(:each) do
      sign_out @user
    end

    it "Renders IRPF field" do
      render

      assert_select "input[type=number][id=customer_irpf]"
    end
  end

  describe 'spanish company' do
    before(:each) do
      @user = create(:user, country: 'ES', tax_id: 'C00000000')
      sign_in @user

      assign(:customer, Customer.new)
    end

    after(:each) do
      sign_out @user
    end

    it "Do not renders IRPF field" do
      render

      assert_select "input[type=number][id=customer_irpf]", false
    end
  end

  describe 'not spanish customers' do
    before(:each) do
      @user = create(:user, country: 'US', tax_id: 'C00000000')
      sign_in @user

      assign(:customer, Customer.new)
    end

    after(:each) do
      sign_out @user
    end

    it "Do not renders IRPF field" do
      render

      assert_select "input[type=number][id=customer_irpf]", false
    end
  end
end
