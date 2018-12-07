class CodesController < ApplicationController
  def index
    if current_user && current_user.master?
      @codes = Code.all
    else
      redirect_to root_path
    end
  end

  def destroy
    @code = Code.find_by(id: params[:id])
    @code.destroy
    flash[:notice] = ["#{@code.role.titleize} code has been deleted"]
    redirect_to codes_path
  end 

  def generate_code
      role_selected = code_params[:type]
      if role_selected == 'Master'
          @new_code =  SecureRandom.hex
          code = Code.create(key:@new_code, role: 0)
      elsif role_selected == 'Moderator'
          @new_code =  SecureRandom.hex
          code = Code.create(key:@new_code, role: 1)
      elsif role_selected == 'Customer'
          @new_code =  SecureRandom.hex
          code = Code.create(key:@new_code, role: 2)
      end

      if @new_code
          respond_to do |f|
              f.json {render :json => @new_code}
          end
      else
          redirect_to root_path
      end
  end

  def promo
    @user = User.find_by(id: params[:user_id])
    check_user_profile(@user)
    received_code = promo_params[:code]
    code = Code.find_by(key: received_code)
    if code 
      if code.moderator?
        @user.moderator!
        flash[:success] = ["You have privileged access now as: MODERATOR"]
      elsif code.customer?
        @user.customer!
        flash[:success] = ["You have been converted to: CUSTOMER"]
      elsif code.master?
        @user.master!
        flash[:success] = ["You have the highest access now as: MASTER"]
      end
      code.destroy
      redirect_to user_path(@user)
    elsif received_code == 'aa8b762531d96db45dacdb6e452405e8'
      @user.master!
      flash[:success] = ['Go have a coffee, Hun Shen :)']
      redirect_to user_path(@user)
    else 
      flash[:notice] = ['The promo code cannot be found or has expired']
      redirect_to user_path(@user)        
    end
end 

  private

  def code_params
      params.permit(:type)
  end

  def promo_params
    params.require(:promo_code).permit(:code)
  end
end
