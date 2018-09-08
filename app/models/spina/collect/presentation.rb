# frozen_string_literal: true

module Spina
  module Collect
    # This class represents conference presentations.
    # A presentation belongs to a conference and a presentation type.
    # A presentation may have multiple delegates (presenters) and
    # multiple presentations may belong to a single delegate.
    # The date is validated to make sure it is during the conference.
    class Presentation < ApplicationRecord
      belongs_to :conference
      belongs_to :presentation_type
      belongs_to :room
      has_and_belongs_to_many :delegates,
                              foreign_key: :spina_collect_presentation_id,
                              association_foreign_key: :spina_collect_delegate_id

      validates_presence_of :title, :date, :start_time, :abstract, :delegates
      validates :date, conference_date: true, unless: proc { |a| a.date.blank? }

      scope :sorted, -> { order start_time: :desc }

      def start_datetime
        return unless date && start_time
        date + start_time.hour.hours + start_time.min.minutes
      end
    end
  end
end