# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentation types
      class PresentationTypesController < ::Spina::Admin::AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]
        before_action :set_conferences, only: %i[new edit]

        layout 'spina/admin/conferences/conferences'

        def index
          @presentation_types = PresentationType.sorted
        end

        def new
          @presentation_type = PresentationType.new
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation_type = PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation_type = PresentationType.new presentation_type_params
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path,
                        flash: { success: t('spina.conferences.presentation_types.saved') }
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation_type = PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path,
                        flash: { success: t('spina.conferences.presentation_types.saved') }
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation_type = PresentationType.find params[:id]
          @presentation_type.destroy
          redirect_to admin_conferences_presentation_types_path,
                      flash: { success: t('spina.conferences.presentation_types.destroyed') }
        end

        def import
          PresentationType.import params[:file]
        end

        private

        def set_conferences
          @conferences = Conference.sorted.to_json methods: %i[name localized_dates],
                                                   include: { sessions: { methods: [:room_name] } }
        end

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.conferences'), admin_conferences_conferences_path
          add_breadcrumb I18n.t('spina.conferences.website.presentation_types'),
                         admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations sessions]
        end

        def presentation_type_params
          params.require(:admin_conferences_presentation_type).permit(:name, :conference_id, :minutes)
        end
      end
    end
  end
end
