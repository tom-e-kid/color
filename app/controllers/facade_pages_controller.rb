class FacadePagesController < ApplicationController
  def home
    if signed_in?
      @issue = current_user.issues.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
