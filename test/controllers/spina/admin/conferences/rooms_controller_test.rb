# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @room = spina_admin_conferences_rooms :lecture_block_2
          @invalid_room = Room.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_rooms_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_room_url
          assert_response :success
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.presentations.no_presentations')
          end
        end

        test 'should create room' do
          assert_difference 'Room.count' do
            attributes = @room.attributes
            attributes[:building] = @room.building
            attributes[:number] = @room.number
            post admin_conferences_rooms_url, params: { admin_conferences_room: attributes }
          end
          assert_redirected_to admin_conferences_rooms_url
          assert_equal 'Room saved', flash[:success]
        end

        test 'should fail to create invalid room' do
          assert_no_difference 'Room.count' do
            attributes = @invalid_room.attributes
            attributes[:building] = @invalid_room.building
            attributes[:number] = @invalid_room.number
            post admin_conferences_rooms_url, params: { admin_conferences_room: attributes }
          end
          assert_response :success
          assert_not_equal 'Room saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_room_url(@room)
          assert_response :success
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update room' do
          attributes = @room.attributes
          attributes[:building] = @room.building
          attributes[:number] = @room.number
          patch admin_conferences_room_url(@room), params: { admin_conferences_room: attributes }
          assert_redirected_to admin_conferences_rooms_url
          assert_equal 'Room saved', flash[:success]
        end

        test 'should fail to update invalid room' do
          attributes = @invalid_room.attributes
          attributes[:building] = @invalid_room.building
          attributes[:number] = @invalid_room.number
          patch admin_conferences_room_url(@room), params: { admin_conferences_room: attributes }
          assert_response :success
          assert_not_equal 'Room saved', flash[:success]
        end

        test 'should destroy room' do
          assert_difference 'Room.count', -1 do
            delete admin_conferences_room_url(@room)
          end
          assert_redirected_to admin_conferences_rooms_url
          assert_equal 'Room deleted', flash[:success]
        end

        test 'should enqueue room import' do
          assert_enqueued_with job: RoomImportJob do
            post import_admin_conferences_rooms_url,
                 params: { file: fixture_file_upload(file_fixture('rooms.csv')) }
          end
        end
      end
    end
  end
end
