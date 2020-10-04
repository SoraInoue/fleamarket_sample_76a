# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up
  def new
    @user = User.new
    @user.build_destination
  end

 
  # POST /resource
  def create
    @user = User.new(user_params)
    unless @user.valid?
      render :new and return
    end
    @user.save
    sign_in @user
    redirect_to root_path
  end

  def mypage

  end

  def logout_page
  end

  def payment_method
  end

  def creditcard
  end

  def profile
  end

  def update
    if current_user.destination.update(destination_update_params)
      redirect_to root_path
    else
      render :destination
    end
  end

  def destination
    
  end
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
    def update_resource(resource, destination_update_params)
      resource.update_without_current_password(destination_update_params)
    end

    def after_update_up_path_for(resource)
      mypage_path(resource)
    end

  # If you have extra params to permit, append them to the sanitizer.

  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up,
  #     keys: [:birthday, :phone_number, :family_name, :first_name, :family_name_kana, :first_name_kana,  
  #       destination_attributes: [:destination_family_name, :destination_first_name, :destination_family_name_kana, :destination_first_name_kana, :postal_code, :prefecture_id, :city, :street_block, :mansion_name, :nickname]])
  # end

  # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :introduction, :destination_family_name, :destination_first_name, :destination_family_name_kana, :destination_first_name_kana, :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number])
    end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #  :new_item(resource)
  # end


  private
  def user_params
    #params.require(:user).permit(:nickname, :email, :password, :family_name, :first_name, :family_name_kana, :first_name_kana, :birthday, :destination_family_name, :destination_first_name, :destination_family_name_kana, :destination_first_name_kana, :postal_code, :prefecture_id, :city, :street_block, :mansion_name)
    params.require(:user).permit(:email, :password, :password_confirmation, :family_name, :first_name, :family_name_kana, :first_name_kana, :birthday, :phone_number,
            destination_attributes: [:destination_family_name, :destination_first_name, :destination_family_name_kana, :destination_first_name_kana, :postal_code, :prefecture_id, :city, :street_block, :mansion_name, :nickname])
  end

  def destination_update_params
    params.require(:destination).permit(:phone_number,:destination_family_name, :destination_first_name, :destination_family_name_kana, :destination_first_name_kana, :postal_code, :prefecture_id, :city, :street_block, :mansion_name, :nickname, :introduction)
  end
end
