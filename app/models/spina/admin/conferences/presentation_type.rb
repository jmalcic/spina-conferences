# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents presentation types (e.g. plenaries, poster presentations, etc.)
      class PresentationType < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { order :name }

        attribute :duration, :interval

        belongs_to :conference, inverse_of: :presentation_types
        has_many :sessions, inverse_of: :presentation_type, dependent: :destroy
        has_many :rooms, through: :sessions
        has_many :presentations, through: :sessions

        validates :name, :minutes, :duration, presence: true
        validates :minutes, numericality: { greater_than_or_equal_to: 1 }
        validates_associated :sessions

        def minutes
          return if duration.blank?

          duration.to_i / ActiveSupport::Duration::PARTS_IN_SECONDS[:minutes]
        end

        def minutes=(minutes)
          self.duration = minutes.to_i.minutes
        end
      end
    end
  end
end
