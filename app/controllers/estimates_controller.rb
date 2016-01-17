class EstimatesController < SecuredController
  before_action :set_estimate, only: [:show, :print, :forward_email, :edit, :update, :destroy]

  # GET /estimates
  # GET /estimates.json
  def index
    @estimates = Estimate.order(date: :desc)
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  # GET /estimates/1/print
  def print
    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        render pdf: "estimate_#{ @estimate.number.gsub('/', '_') }", viewport_size: '1920x1080'
      end
    end
  end

  def forward_email
    file_name =  "estimate_#{ current_user.id }_#{ @estimate.number.gsub('/', '_') }_#{ Time.now.to_i }"
    pdf = render_to_string pdf: file_name, template: 'estimates/print.pdf.erb', encoding: 'UTF-8'

    # then save to a file
    save_path = Rails.root.join('tmp',"#{ file_name }.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    EstimateMailer.send_to_customer(current_user, @estimate, save_path.to_s, I18n.locale.to_s).deliver_later
    redirect_to user_estimate_path(current_user.id, @estimate.id), notice: t('helpers.email_successfully_sent')
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
    @estimate.estimate_details.build
  end

  # GET /estimates/1/edit
  def edit
    @estimate_detail = EstimateDetail.new
    @estimate.estimate_details.includes(service: [ :unit, :vat ]).build
  end

  # POST /estimates
  # POST /estimates.json
  def create
    Estimate.transaction do
      @estimate = Estimate.new(estimate_params)

      respond_to do |format|
        if @estimate.save
          format.html {
            redirect_to edit_user_estimate_url(current_user, @estimate),
            notice: t(:successfully_created, item: t('estimates.estimate'))
          }
          format.json { render :show, status: :created, location: @estimate }
        else
          format.html { render :new }
          format.json { render json: @estimate.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
    Estimate.transaction do
      respond_to do |format|
        if @estimate.update(estimate_params)
          format.html {
            redirect_to edit_user_estimate_url(current_user, @estimate),
            notice: t(:successfully_updated, item: t('estimates.estimate'))
          }
          format.json { render :show, status: :ok, location: @estimate }
        else
          format.html { render :edit }
          format.json { render json: @estimate.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html {
        redirect_to user_estimates_url(current_user),
        notice: t(:successfully_destroyed, item: t('estimates.estimate'))
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimate_params
      params.require(:estimate).permit(
        :date,
        :number,
        :customer_id,
        :valid_until,
        :estimate_status_id,
        estimate_details_attributes: [
          :id, :estimate_id, :service_id, :quantity, :price,
          :discount, :description, :_destroy
        ]
      )
    end
end
