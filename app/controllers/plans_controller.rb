# frozen_string_literal: true

# Controller that deals with plan related actions
class PlansController < AdminSecuredController
  before_action :set_plan, only: %i[show edit update destroy]

  # GET /plans
  # GET /plans.json
  def index
    authorize! :index, Plan

    @filterrific = initialize_filterrific(
      Plan,
      params[:filterrific],
      select_options: {
        sorted_by: Plan.options_for_sorted_by,
        with_active_criteria: Plan.active_filter_options
      }
    ) || return

    @plans = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    authorize! :show, Plan
  end

  # GET /plans/new
  def new
    authorize! :create, Plan
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
    authorize! :update, Plan
  end

  # POST /plans
  # POST /plans.json
  def create
    authorize! :create, Plan
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to plans_path, notice: t(:successfully_created, item: t('plans.plan'))
    else
      render :new
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    authorize! :update, Plan

    if @plan.update(plan_params)
      redirect_to @plan, notice: t(:successfully_updated, item: t('plans.plan'))
    else
      render :edit
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    authorize! :destroy, Plan
    @plan.destroy
    redirect_to plans_url, notice: t(:successfully_destroyed, item: t('plans.plan'))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:description, :vat_rate, :price, :months, :is_active)
  end
end
