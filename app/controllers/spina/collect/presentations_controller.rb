module Spina
  module Collect
    # This class shows presentations
    class PresentationsController < ::Spina::ApplicationController

      def index
        @presentations = Presentation.all
      end

      def show
        @presentation ||= Presentation.find(params[:id])
      end

    end
  end
end
