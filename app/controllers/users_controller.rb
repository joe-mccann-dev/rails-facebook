class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = other_users
    @friends = current_user.friends
    @results = User.search(params[:query])
  end

  def show
    @profile = @user.profile
    @post = current_user.posts.build
    @posts = @user.posts.with_attached_image
                  .includes([:image_attachment, :comments, :likes, :likers])
                  .order(created_at: :desc)
    @friendship = current_user.requests_via_sender_id[@user.id]
    return unless current_user.pending_received_friends.any?

    @notification = Notification.find_by(sender_id: @user.id,
                                         receiver_id: current_user.id,
                                         object_type: 'Friendship')
  end

  def other_users
    User.where.not(id: [current_user.id, current_user.friends.map(&:id)].flatten)
  end

  def show_friends
    respond_to do |format|
      format.js do
        @friendships = current_user.friendships_via_friend_id
        @friends = current_user.friends
      end
    end
  end

  def show_other_users
    respond_to do |format|
      format.js do
        @users = other_users
        @friendship = current_user.sent_pending_requests.build
      end
    end
  end

  private

  def set_user
    # return current_user if user navigates to /profile
    @user = if params[:id].present?
              User.find(params[:id])
            else
              current_user
            end
  end
end
