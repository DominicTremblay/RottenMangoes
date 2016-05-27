class Movie < ActiveRecord::Base

  UNDER_90_MINUTES = 0
  BETWEEN_90_AND_120 = 90
  OVER_120 = 120

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster_image_url,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  mount_uploader :poster_image_url, ImageUploader

  def self.search(search, type, duration)
  
    movies = Movie.all
    if search && !search.empty?
      query = "#{type} like ?"
      #query = "director like ?" if type == "director"
      movies = movies.where(query,"%#{search}%")
    end

    if duration
      case duration.to_i
        when UNDER_90_MINUTES then
          movies = movies.where("runtime_in_minutes < ?", 90)
        when BETWEEN_90_AND_120 then
          movies = movies.where("runtime_in_minutes >= ? AND runtime_in_minutes <= ?", 90, 120)
        when OVER_120 then
          movies = movies.where("runtime_in_minutes > ?", 120)
      end
    end
 
    movies

  end

  def review_average
    reviews.size == 0 ? 0 : reviews.sum(:rating_out_of_ten)/reviews.size
  end

  

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
