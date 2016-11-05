class UsersController < AdminSecuredController
  before_action :set_user, only: [:edit, :update, :ban]
  before_action :check_admin_role, except: [ :renew ]

  # GET /users
  # GET /users.json
  def index
    @filterrific = initialize_filterrific(
        User,
        params[:filterrific],
        default_filter_params: {
            sorted_by: 'valid_until_asc',
            with_active_criteria: 'all'
        },
        select_options: {
            sorted_by: User.options_for_sorted_by,
            with_active_criteria: User.active_filter_options
        }
    ) or return

    @users = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to  users_url, notice: t(:successfully_updated, item: t('users.user')) }
        format.json { respond_with_bip @user }
      else
        format.html { render :edit }
        format.json { respond_with_bip @user }
      end
    end
  end

  def ban
    @user.banned = true
    if @user.save
      redirect_to users_url, notice: t('users.successfully_banned')
    else
      redirect_to users_url, flash: { error: @user.errors.full_messages.join(', ') }
    end
  end

  def renew
    unless current_user.can_invoice?
      redirect_to edit_user_registration_path(current_user), flash: { error: I18n.t('users.invoice_data_missing_error') }
    end
  end

  def renew_sent
    redirect_to edit_user_path(current_user), notice: t('users.renew_request_processed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:valid_until, :role_id)
  end
end
