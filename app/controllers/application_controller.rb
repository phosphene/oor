class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_blog

  # make all model requests from controllers run through the exhibits
  # helper to figure out which exhibit facade we should query for information
  helper :exhibits

  private
  def init_blog
    @blog = THE_BLOG
  end
end
