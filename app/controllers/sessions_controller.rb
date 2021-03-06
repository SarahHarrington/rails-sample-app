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
      if user.activated?
        #* the log_in and remember methods are both in the sessions_helper
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
        #* redirects don't happen until an explicit return or the end of the method
        #* any code after the redirect is still executed
      else
        message = "Account not activated"
        message += "Check your email for the activation link."
        flashp[:warning] = message
        redirect_to root_url
      end
    else
      #n create an error message - flash is a built in thing
      #* flash.now makes it so it only displays on the page once
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
