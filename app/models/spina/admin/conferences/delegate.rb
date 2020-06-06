# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents conference delegates.
      class Delegate < ApplicationRecord
        scope :sorted, -> { order :last_name, :first_name }

        belongs_to :institution, inverse_of: :delegates
        has_and_belongs_to_many :conferences, foreign_key: :spina_conferences_delegate_id,
                                              association_foreign_key: :spina_conferences_conference_id
        has_and_belongs_to_many :presentations, foreign_key: :spina_conferences_delegate_id,
                                                association_foreign_key: :spina_conferences_presentation_id
        has_and_belongs_to_many :dietary_requirements, foreign_key: :spina_conferences_delegate_id,
                                                       association_foreign_key: :spina_conferences_dietary_requirement_id

        validates :first_name, :last_name, presence: true
        validates :email_address, 'spina/admin/conferences/email_address': true
        validates :url, 'spina/admin/conferences/http_url': true

        def self.import(file)
          DelegateImportJob.perform_later IO.read(file)
        end

        # Returns first name and last name, used to address delegates.
        def full_name
          return if first_name.blank? || last_name.blank?

          Delegate.human_attribute_name :full_name, first_name: first_name, last_name: last_name
        end

        # Returns full name and institution, used to identify delegates.
        def full_name_and_institution
          return if full_name.blank? || institution.blank?

          Delegate.human_attribute_name :name_and_institution, name: full_name, institution: institution.name
        end

        # Returns last name and first name, used for sorting delegates.
        def reversed_name
          return if first_name.blank? || last_name.blank?

          Delegate.human_attribute_name :reversed_name, first_name: first_name, last_name: last_name
        end

        # Returns reversed name and institution, used for sorting delegates.
        def reversed_name_and_institution
          return if reversed_name.blank? || institution.blank?

          Delegate.human_attribute_name :name_and_institution, name: reversed_name, institution: institution.name
        end
      end
    end
  end
end
