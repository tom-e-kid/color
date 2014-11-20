class FacadePagesController < ApplicationController
  def home
    if signed_in?
      @task = current_user.tasks.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
