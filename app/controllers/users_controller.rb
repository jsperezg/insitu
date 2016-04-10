class UsersController < AdminSecuredController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :ban]

  # GET /users
  # GET /users.json
  def index
    @filterrific = initialize_filterrific(
        User,
        params[:filterrific],
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

  # GET /users/1
  # GET /users/1.json
  def show
    render nothing: true, status: :service_unavailable
  end

  # GET /users/new
  def new
    render nothing: true, status: :service_unavailable
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    render nothing: true, status: :service_unavailable
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
      redirect_to users_url, error: @user.errors.full_messages.join(', ')
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: t(:successfully_destroyed, item: t('users.user')) }
      format.json { head :no_content }
    end
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
