class Api::V1::CustomersController < ApiController
  include Api

  before_action :set_customer, only: [:show, :update, :destroy]

  def index
    @customers = Customer.order(name: :asc)
  end

  def show
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.save
    render 'show'
  end

  def update
    @customer.update(customer_params)
    render 'show'
  end

  def destroy
    @customer.destroy
    render json: ResponseFactory.get_response_for(@customer)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params
        .require(:customer)
        .permit(
            :name, :tax_id, :billing_serie, :irpf, :contact_name, :contact_phone, :contact_email,
            :address, :city, :country, :state, :postal_code, :send_invoices_to
        )
  end
end