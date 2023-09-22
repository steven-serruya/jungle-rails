class SessionsController < ApplicationController
  def new
end

def create
  @user = User.find_by(email: params[:session][:email].strip.downcase)
  puts "Found user: #{@user.inspect}"
  if @user && @user.authenticate(params[:session][:password])
    session[:user_id] = @user.id
    redirect_to root_path, notice: 'Logged in!'
  else
    puts "Failed to authenticate user"
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end
end

def destroy
  session[:user_id] = nil
  redirect_to root_path, notice: "Logged out!"
end

end
