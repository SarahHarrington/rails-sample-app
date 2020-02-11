class SessionsController < ApplicationController
  def new
  end

  def create
    #n User.find_by does a query to find the user
    #* params is a hash
    #* session is a hash
    #sn The if is checking if the user and the submitted authenticated password match
    #* the authenticate method returns false for invalid authentication

    user = User.find_by(email: params[:session][:email].downcase)
    #n The user needs to be found and authenticated returns true to log in
    if user && user.authenticate(params[:session][:password])
      #* the log_in and remember methods are both in the sessions_helper
      log_in user
      remember user
      redirect_to user
    else
      #n create an error message - flash is a built in thing
      #* flash.now makes it so it only displays on the page once
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
