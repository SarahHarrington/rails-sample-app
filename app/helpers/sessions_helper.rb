#n This was automatically generated when the sessions controller was created
#n Since this is in the base class of all controllers (application_controller as a module)
#n it is available to all of the controllers
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    #n the user.remember calls the remember method in the User class and creates
    #n the remember token that is then saved to the database
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      #n This will check if there is a session id for user_id
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #n If there is no session, it checks for a cookie user_id
      user = User.find_by(id: user_id)
      #n if the user is found, authentication occurs
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end


  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
