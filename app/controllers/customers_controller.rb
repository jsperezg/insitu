# frozen_string_literal: true

require 'csv_import_service'
require 'csv_to_customer_converter'

# Controller for customer related actions
class CustomersController < SecuredController
  before_action :set_customer, only: %i[show edit update destroy]

  # GET /customers
  # GET /customers.json
  def index
    @filterrific = initialize_filterrific(
      Customer,
      params[:filterrific]
    ) || return

    respond_to do |format|
      format.html { @customers = @filterrific.find.page(params[:page]) }
      format.js { @customers = @filterrific.find.page(params[:page]) }

      format.json do
        @customers = if params[:name]
                       Customer.where('name like ?', "%#{params[:name]}%").order(name: :asc)
                     else
                       Customer.order(name: :asc)
                     end
      end
    end
  end

  # GET /customers/1.json
  def show; end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit; end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      respond_to_create_success
    else
      respond_to_create_failure(@customer)
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    if @customer.update(customer_params)
      redirect_to user_customers_url(current_user), notice: t(:successfully_updated, item: t('customers.customer'))
    else
      render :edit
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    if @customer.destroy
      redirect_to user_customers_url(current_user), notice: t(:successfully_destroyed, item: t('customers.customer'))
    else
      redirect_to user_customers_url(current_user), alert: @customer.errors.full_messages.join('<br>')
    end
  end

  def csv_template
    customer_converter = CsvToCustomerConverter.new
    send_data customer_converter.template, type: Mime::CSV, filename: "#{Customer.model_name.human(count: 2)}.csv"
  end

  def csv_import
    csv = params[:csv_file]

    customer_converter = CsvToCustomerConverter.new
    import_service = CSVImportService.new(customer_converter)

    result = import_service.import Rails.root.join('public', 'uploads', csv.path)
    redirect_to user_customers_path(current_user), flash: { error: result.join('<br>') }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def respond_to_create_failure(customer)
    respond_to do |format|
      format.html { render :new }
      format.json { render json: customer.errors, status: :unprocessable_entity }
    end
  end

  def respond_to_create_success
    respond_to do |format|
      format.html { redirect_to user_customers_url(current_user), notice: t(:successfully_created, item: t('customers.customer')) }
      format.json { render :show, status: :created }
    end
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
