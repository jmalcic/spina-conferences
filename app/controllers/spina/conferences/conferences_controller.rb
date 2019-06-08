# frozen_string_literal: true

module Spina
  module Conferences
    # This class serves conferences as iCal
    class ConferencesController < ApplicationController
      include Eventable

      def index
        @conferences = Conference.sorted
        respond_to do |format|
          format.ics { render body: make_calendar(@conferences, name: current_account.name).to_ical }
        end
      end

      def show
        @conference = Conference.find(params[:id])
        respond_to do |format|
          format.ics do
            render body: make_calendar(@conference, @conference.presentations, name: @conference.name).to_ical
          end
        end
      end
    end
  end
end
