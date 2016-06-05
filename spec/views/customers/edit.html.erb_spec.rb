require 'rails_helper'

RSpec.describe "customers/edit", type: :view do
  describe('generic validations') do
    before(:each) do
      @user = create(:user)
      sign_in @user

      @customer = assign(:customer, create(:customer))
    end

    after(:each) do
      sign_out @user
    end

    it "renders the edit customer form" do
      render

      assert_select "form[action=?][method=?]", user_customer_path(@user, @customer), "post"
    end
  end

  describe 'spanish freelancer' do
    before(:each) do
      @user = create(:user, country: 'ES', tax_id: '00000000L')
      sign_in @user

      @customer = assign(:customer, create(:customer))
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

      @customer = assign(:customer, create(:customer))
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

      @customer = assign(:customer, create(:customer))
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
