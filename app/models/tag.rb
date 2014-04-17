class Tag < ActiveRecord::Base
  has_many(
    :tag_links,
    class_name: "TagLink",
    foreign_key: :tag_id,
    primary_key: :id
  )

  has_many :links, through: :tag_links, source: :link

  def most_popular
    query = <<-SQL
    SELECT
      COUNT(shortened_urls.*)
    FROM
      visits
    JOIN
      shortened_urls
    ON
      shortened_urls.id = visits.shortened_id
    GROUP BY
      visits.shortened_id
    LIMIT
      3
    SQL

    ShortenedUrl.find_by_sql(query)
  end

  def most_popular_rails
     # posts_with_counts = self
     #  .posts
     #  .select("posts.*, COUNT(*) AS comments_count") # more in a sec
     #  .joins(:comments)
     #  .group("posts.id")

    links_with_counts = self
      .tag_links
      .select("tag_links.*, COUNT(*) AS tags_count")
      .joins(:link)
      .group("shortened_urls.id")


    # ShortenedUrl.joins(:visits).group("visits.shortened_id").order(
    #   "COUNT(visits.id)").where("tag_id", self.id)limit(5)

    # self.tag_links#.includes(:link)
    #   .select("tag_links.*, COUNT(*) AS count")
    #   .joins(:link)
    #   .group("tag_links.tag_id")
  end

end