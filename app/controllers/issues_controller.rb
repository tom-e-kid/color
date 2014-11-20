class IssuesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @issue = current_user.issues.build(issue_params)
    if @issue.save
      flash[:success] = "Issue created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'facade_pages/home'
    end
  end

  def destroy
    @issue.destroy
    redirect_to root_url
  end


  private

    def issue_params
      params.require(:issue).permit(:content)
    end

    def correct_user
      @issue = current_user.issues.find_by(id: params[:id])
      redirect_to root_url if @issue.nil?
    end
end