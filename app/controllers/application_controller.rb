class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  private

  def verify_object_viewable(object)
    unless object.user == current_user || object.user.friends.include?(current_user)
      flash[:warning] = "You must be friends with the author to view this #{object.class.to_s.downcase}"
      redirect_to root_url
    end
  end

  def object_to_s(object)
    object.class.to_s.downcase
  end

  def determine_path(object)
    objects = {
      'Post' => post_path(object),
      'Comment' => comment_path(object)
    }
    objects[object.class.to_s]
  end
end
