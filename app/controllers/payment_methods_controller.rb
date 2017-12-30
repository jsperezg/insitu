# frozen_string_literal: true

# Controller that deals  with payment method  management.
class PaymentMethodsController < SecuredController
  before_action :set_payment_method, only: %i[show edit update destroy]

  # GET /payment_methods
  # GET /payment_methods.json
  def index
    @payment_methods = PaymentMethod.all
  end

  # GET /payment_methods/1
  # GET /payment_methods/1.json
  def show; end

  # GET /payment_methods/new
  def new
    @payment_method = PaymentMethod.new
  end

  # GET /payment_methods/1/edit
  def edit; end

  # POST /payment_methods
  def create
    @payment_method = PaymentMethod.new(payment_method_params)

    if @payment_method.save
      redirect_to user_payment_methods_path(current_user.id), notice: t(:successfully_created, item: t(:payment_method))
    else
      render :new
    end
  end

  # PATCH/PUT /payment_methods/1
  # PATCH/PUT /payment_methods/1.json
  def update
    if @payment_method.update(payment_method_params)
      redirect_to user_payment_methods_path(current_user.id), notice: t(:successfully_updated, item: t(:payment_method))
    else
      render :edit
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.json
  def destroy
    if @payment_method.destroy
      redirect_to user_payment_methods_url(current_user.id), notice: t(:successfully_destroyed, item: t(:payment_method))
    else
      redirect_to user_payment_methods_url(current_user.id), alert: @payment_method.errors.full_messages.join('<br>')
    end
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
