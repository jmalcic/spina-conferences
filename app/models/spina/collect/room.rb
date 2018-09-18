# frozen_string_literal: true

module Spina
  module Collect
    # This class represents rooms in an institution.
    # A `Room` belongs to an `:institution`, and has many `:presentations`.
    # A `Room` may have many `:presentation_types`, and a
    # `PresentationType` may have many `:rooms`.
    class Room < ApplicationRecord
      belongs_to :institution, inverse_of: :rooms
      has_many :room_possessions, dependent: :destroy
      has_many :room_uses, through: :room_possessions
      has_many :presentations, through: :room_uses

      validates_presence_of :number, :building

      def building_and_number
        "#{building} #{number}"
      end
    end
  end
end
