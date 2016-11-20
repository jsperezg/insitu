class Api::V1::PaymentMethodsController < ApiController
  include Api

  before_action :set_payment_method, only: [:show, :update, :destroy]

  # GET /payment_methods
  # GET /payment_methods.json
  def index
    @payment_methods = PaymentMethod.all
  end

  # GET /payment_methods/1
  # GET /payment_methods/1.json
  def show
  end


  # POST /payment_methods
  # POST /payment_methods.json
  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@payment_method)
    end
  end

  # PATCH/PUT /payment_methods/1
  # PATCH/PUT /payment_methods/1.json
  def update
    if @payment_method.update(payment_method_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@payment_method)
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.json
  def destroy
    @payment_method.destroy
    render json: ResponseFactory.get_response_for(@payment_method)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_method_params
    params.require(:payment_method).permit(:name, :note_for_invoice, :default)
  end
end
