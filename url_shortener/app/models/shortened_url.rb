class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, presence: true, uniqueness: true
  validates :short_url, presence: true

  belongs_to(
    :submitter,
    :class_name => "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    :class_name => "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(:visitors, through: :visits, source: :visitors)


  def self.random_code
    code = SecureRandom::urlsafe_base64
    return code unless ShortenedUrl.exists?(:short_url => code)
    ShortenedUrl.random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(:submitter_id => user.id, :long_url => long_url,
    :short_url => ShortenedUrl.random_code)
  end

  def num_clicks
    visitors.count
  end

  def num_uniques
    visitors.distinct.count
  end

  def num_recent_uniques
    visitors.where((Time.now - visits.created_at) < 10.minutes).distinct.count
  end




end
