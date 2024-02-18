class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  def edit; end

  def update
    @user = User.find(params[:id])
    percentage = params[:user][:on_track_percentage].to_f / 100
    if @user.update(on_track_percentage: percentage)
      redirect_to @user, notice: 'Actualizado.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:on_track_percentage)
  end
end
