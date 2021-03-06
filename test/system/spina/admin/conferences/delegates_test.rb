# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class DelegatesTest < ApplicationSystemTestCase
        setup do
          @delegate = spina_admin_conferences_delegates :joe_bloggs
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_delegates_path
          assert_selector '.breadcrumbs' do
            assert_text 'Delegates'
          end
          Percy.snapshot page, name: 'Delegates index'
        end

        test 'creating a delegate' do
          visit admin_conferences_delegates_path
          click_on 'New delegate'
          assert_selector '.breadcrumbs' do
            assert_text 'New delegate'
          end
          fill_in 'admin_conferences_delegate_first_name', with: @delegate.first_name
          fill_in 'admin_conferences_delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'admin_conferences_delegate_institution_id'
          fill_in 'admin_conferences_delegate_email_address', with: @delegate.email_address
          fill_in 'admin_conferences_delegate_url', with: @delegate.url
          @delegate
            .conferences.each { |conference| select conference.name, from: 'admin_conferences_delegate_conference_ids' }
          Percy.snapshot page, name: 'Delegates form on create'
          click_on 'Save delegate'
          assert_text 'Delegate saved'
          Percy.snapshot page, name: 'Delegates index on create'
        end

        test 'updating a delegate' do
          visit admin_conferences_delegates_path
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @delegate.full_name
          end
          Percy.snapshot page, name: 'Delegates form on update'
          fill_in 'admin_conferences_delegate_first_name', with: @delegate.first_name
          fill_in 'admin_conferences_delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'admin_conferences_delegate_institution_id'
          fill_in 'admin_conferences_delegate_email_address', with: @delegate.email_address
          fill_in 'admin_conferences_delegate_url', with: @delegate.url
          @delegate
            .conferences.each { |conference| select conference.name, from: 'admin_conferences_delegate_conference_ids' }
          click_on 'Save delegate'
          assert_text 'Delegate saved'
          Percy.snapshot page, name: 'Delegates index on update'
        end

        test 'destroying a delegate' do
          visit admin_conferences_delegates_path
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @delegate.full_name
          end
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the delegate #{@delegate.full_name}?"
          Percy.snapshot page, name: 'Delegates delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Delegate deleted'
          assert_no_selector "tr[data-delegate-id=\"#{@delegate.id}\"]"
          Percy.snapshot page, name: 'Delegates index on delete'
        end
      end
    end
  end
end
