class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :comments
  has_many :likes
  has_many :liked_posts, through: :likes, source: :posts
  has_one :profile

  # PENDING FRIEND REQUESTS
  has_many :sent_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  has_many :received_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # ACCEPTED FRIEND REQUESTS
  # the one requesting the friendship is the 'sender', -> foreign_key is sender_id
  has_many :sent_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  # the one accepting the friendship is the 'receiver', -> foreign_key is receiver_id
  has_many :received_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # DECLINED FRIEND REQUESTS
  has_many :sent_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  has_many :received_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # FRIENDS
  # the receivers of a user's friend requests are friends once status is 'accepted'
  has_many :requested_friends,
           through: :sent_accepted_requests,
           source: :receiver
  # those who sent a user friend requests are friends once status is 'accepted'
  has_many :received_friends,
           through: :received_accepted_requests,
           source: :sender

  def friends
    requested_friends + received_friends
  end

  def pending_requests
    sent_pending_requests + received_pending_requests
  end

  def accepted_requests
    sent_accepted_requests + received_accepted_requests
  end

  def declined_requests
    sent_declined_requests + received_declined_requests
  end

  def friend_requests
    pending_requests + accepted_requests + declined_requests
  end
end
