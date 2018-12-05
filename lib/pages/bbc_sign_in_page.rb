require 'capybara/dsl'

class BbcSignInPage
  include Capybara::DSL

  SIGN_IN_PAGE_URL = 'https://account.bbc.com/signin'
  USER_IDENTIFIER_FIELD_ID = 'user-identifier-input'
  USER_IDENTIFIER_FIELD_ID_CSS = '#user-identifier-input'
  GENERAL_ERROR_MESSAGE_ID = '#form-message-general'
  USER_ERROR_MESSAGE_ID = '#form-message-username'
  PASSWORD_FIELD_ID = 'password-input'
  PASSWORD_FIELD_ID_CSS = '#password-input'
  PASSWORD_ERROR_MESSAGE_ID = '#form-message-password'

  def visit_sign_in_page
    visit(SIGN_IN_PAGE_URL)
  end

  def enter_user_identifier_field (input)
    fill_in(USER_IDENTIFIER_FIELD_ID, :with => input)
  end

  def enter_password_field (input)
    fill_in(PASSWORD_FIELD_ID, :with => input)
  end

  def submit_username
    find(USER_IDENTIFIER_FIELD_ID_CSS).native.send_keys(:return)
  end

  def submit_password
    find(PASSWORD_FIELD_ID_CSS).native.send_keys(:return)
  end

  def get_username_error_message
    find(USER_ERROR_MESSAGE_ID).text
  end

  def get_password_error_message
    find(PASSWORD_ERROR_MESSAGE_ID).text
  end

  def get_general_error_message
    find(GENERAL_ERROR_MESSAGE_ID).text
  end

  def check_username_error_message_visibility
    begin
      find(USER_ERROR_MESSAGE_ID)
    rescue
      false
    else
      true
    end
  end

  def check_password_error_message_visibility
    begin
      find(PASSWORD_ERROR_MESSAGE_ID)
    rescue
      false
    else
      true
    end
  end

end
