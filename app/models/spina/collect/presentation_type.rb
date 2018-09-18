# frozen_string_literal: true

module Spina
  module Collect
    # This class represents presentation types (e.g. plenaries, poster
    # presentations, etc.)
    # A presentation type has many presentations, belongs to a
    # conference, and has and belongs to many rooms.
    class PresentationType < ApplicationRecord
      belongs_to :conference, inverse_of: :presentation_types
      has_many :room_uses, dependent: :destroy
      has_many :room_possessions, through: :room_uses
      has_many :presentations, through: :room_uses

      validates_presence_of :name, :minutes
      validates_numericality_of :minutes, greater_than_or_equal_to: 1
      validates_associated :room_uses

      scope :sorted, -> { order :name }

      def minutes
        duration / ActiveSupport::Duration::SECONDS_PER_MINUTE if duration
      end

      def minutes=(minutes)
        assign_attributes(duration: "PT#{minutes}M")
      end
    end
  end
end
