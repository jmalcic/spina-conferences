# frozen_string_literal: true

class CreateSpinaCollectDietaryRequirements < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_dietary_requirements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
