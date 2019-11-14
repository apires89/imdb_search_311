class Movie < ApplicationRecord
  belongs_to :director
  after_save :rebuild_search
  include PgSearch::Model
  multisearchable against: [:title, :syllabus]
  pg_search_scope :search,
    against: [ :title, :syllabus ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
  pg_search_scope :global_search,
   against: [:title, :syllabus],
    associated_against: {
      director: [:first_name, :last_name]
    },
    using: {
     tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

    def rebuild_search
      PgSearch::Multisearch.rebuild(Movie)
    end
end
