require 'csv_import_service'
require 'csv_to_customer_converter'

class CustomersController < SecuredController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @filterrific = initialize_filterrific(
        Customer,
        params[:filterrific]
    ) or return

    respond_to do |format|
      format.html {
        @customers = @filterrific.find.page(params[:page])
      }

      format.js {
        @customers = @filterrific.find.page(params[:page])
      }

      format.json {
        if params[:name]
          @customers = Customer.where('name like ?', "%#{ params[:name] }%").order(name: :asc)
        else
          @customers = Customer.order(name: :asc)
        end
      }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to user_customers_url(current_user), notice: t(:successfully_created, item: t('customers.customer')) }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to user_customers_url(current_user), notice: t(:successfully_updated, item: t('customers.customer')) }
        format.json { respond_with_bip @customer }
      else
        format.html { render :edit }
        format.json { respond_with_bip @customer }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    if @customer.destroy
      respond_to do |format|
        format.html { redirect_to user_customers_url(current_user), notice: t(:successfully_destroyed, item: t('customers.customer')) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to user_customers_url(current_user), alert: @customer.errors.full_messages.join('<br>') }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def csv_template
    customer_converter = CsvToCustomerConverter.new
    send_data customer_converter.template, type: Mime::CSV, filename: "#{ Customer.model_name.human(count: 2) }.csv"
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
