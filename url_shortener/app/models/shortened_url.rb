class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, presence: true, uniqueness: true
  validates :short_url, presence: true

  belongs_to(
    :submitter,
    :class_name => "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  def self.random_code
    code = SecureRandom::urlsafe_base64
    return code unless ShortenedUrl.exists?(:short_url => code)
    ShortenedUrl.random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(:submitter_id => user.id, :long_url => long_url,
    :short_url => ShortenedUrl.random_code)
  end




end
