require 'spec_helper'

describe 'Incorrect user details produces valid error' do

  context 'it should respond with the correct error when incorrect details are input' do

    context 'username checks' do

      it "should produce a username error when submitting an empty username field" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_homepage.visit_homepage
        @bbc_site.bbc_homepage.click_sign_in_link

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('')
        @bbc_site.bbc_sign_in_page.submit_username
        expect(@bbc_site.bbc_sign_in_page.get_username_error_message).to include ('Something')
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should produce a username error when submitting an invalid username" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('Obi-wan[]')
        @bbc_site.bbc_sign_in_page.submit_username
        expect(@bbc_site.bbc_sign_in_page.get_username_error_message).to include ('only include')
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should not produce a username error when submitting an invalid username" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('Obi-wan')
        @bbc_site.bbc_sign_in_page.submit_username
        if(@bbc_site.bbc_sign_in_page.check_username_error_message_visibility)
          raise "username error message should not exist"
        end
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end
    end

    context "password checks" do

      it "should produce a password error when submitting an empty password field" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.submit_password
        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to include ('Something')
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should produce a password error when submitting a password that is too short" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_password_field('0')
        @bbc_site.bbc_sign_in_page.submit_password
        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to include ('too short')
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should produce a password error when submitting a password that contains a quote mark" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_password_field("happymeal1'")
        @bbc_site.bbc_sign_in_page.submit_password
        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to include ('quote marks')
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should produce a password error when submitting a password that only contains letters" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_password_field("happymeal")
        @bbc_site.bbc_sign_in_page.submit_password
        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to include ("isn't a letter")
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should produce a password error when submitting a password that doesn't contain letters" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_password_field("218479123")
        @bbc_site.bbc_sign_in_page.submit_password
        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to include ("include a letter")
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

      it "should not produce a password error when submitting a valid password" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_password_field("happy123")
        @bbc_site.bbc_sign_in_page.submit_password
        if(@bbc_site.bbc_sign_in_page.check_password_error_message_visibility)
          raise "password error message should not exist"
        end
        expect(@bbc_site.bbc_sign_in_page.get_general_error_message).to include ('Sorry')
      end

    end
    context "check valid username & password" do
      it "should not accept a valid username & password if the username does not match an account" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('Obi-wan-happy')
        @bbc_site.bbc_sign_in_page.enter_password_field("happy123")
        @bbc_site.bbc_sign_in_page.submit_password

        expect(@bbc_site.bbc_sign_in_page.get_username_error_message).to eq ("Sorry, we can’t find an account with that username. If you're over 13, try your email address instead or get help here.")
      end

      it "should not accept a valid username & password if the password does not match that account" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('happy@cheese.com')
        @bbc_site.bbc_sign_in_page.enter_password_field("happy1234")
        @bbc_site.bbc_sign_in_page.submit_password

        expect(@bbc_site.bbc_sign_in_page.get_password_error_message).to eq ("That's not the right password for that account. Reset your password here.")
        # currently, this is failing. It's returning an unexpected error message, that I am unable to reproduce.
      end

      it "should accept a valid username & password" do
        @bbc_site = BbcSite.new
        @bbc_site.bbc_sign_in_page.visit_sign_in_page

        @bbc_site.bbc_sign_in_page.enter_user_identifier_field('happy@cheese.com')
        @bbc_site.bbc_sign_in_page.enter_password_field("happy123")
        @bbc_site.bbc_sign_in_page.submit_password

        expect(@bbc_site.bbc_sign_in_page.current_url).to eq ("https://www.bbc.co.uk/")
      end
    end

  end

end
