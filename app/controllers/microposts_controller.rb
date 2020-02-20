class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:sucess] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_page/home'
    end
  end

  def destroy

  end

  private

  def micropost_params
    #* this allows only the content to be modified via the web
    params.require(:micropost).permit(:content)
  end

end
