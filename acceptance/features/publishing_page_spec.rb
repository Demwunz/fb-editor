# coding: utf-8
require_relative '../spec_helper'

feature 'Publishing' do
  let(:editor) { EditorApp.new }
  let(:service_name) { generate_service_name }
  let(:page_url) { 'palpatine' }
  let(:exit_url) { 'exit' }
  let(:warning_both) { I18n.t('publish.warning.both_pages') }
  let(:warning_cya) { I18n.t('publish.warning.cya') }
  let(:warning_confirmation) { I18n.t('publish.warning.confirmation') }
  let(:modal_description) { I18n.t('activemodel.attributes.publish_service_creation.description') }
  let(:allow_anyone_text) { I18n.t('publish.dialog.option_1') }
  let(:username_and_password_text) { I18n.t('publish.dialog.option_2') }
  let(:username_and_password_errors) do
    # the use of '‘' is correct
    [
      "Your answer for ‘Create a username’ is too short (6 characters at least)",
      "Your answer for ‘Create a password’ is too short (6 characters at least)",
    ]
  end

  background do
    given_I_am_logged_in
    given_I_have_a_service_fixture(fixture: 'default_new_service_fixture')
  end

  scenario 'when visiting the publishing page with submitting pages present' do
    given_I_have_a_single_question_page_with_upload
    and_I_return_to_flow_page
    when_I_visit_the_publishing_page
    then_I_should_be_on_the_publishing_page
    then_I_should_not_see_warning_both_text
    then_I_should_not_see_warning_cya_text
    then_I_should_not_see_warning_confirmation_text
  end

  scenario 'when visiting the publishing page without submitting pages present' do
    given_I_have_a_single_question_page_with_upload
    and_I_return_to_flow_page
    given_I_add_an_exit_page
    when_I_visit_the_publishing_page
    then_I_should_be_on_the_publishing_page
    then_I_should_see_warning_both_text
    then_I_should_not_see_warning_cya_text
    then_I_should_not_see_warning_confirmation_text
  end

  scenario 'when visiting the publishing page without cya page present' do
    given_I_have_a_single_question_page_with_upload
    and_I_return_to_flow_page
    and_I_delete_cya_page
    then_I_should_see_delete_warning_cya
    when_I_visit_the_publishing_page
    then_I_should_be_on_the_publishing_page
    then_I_should_not_see_warning_both_text
    then_I_should_not_see_warning_confirmation_text
    then_I_should_see_warning_cya_text
  end

  scenario 'when visiting the publishing page without confirmation page present' do
    given_I_have_a_single_question_page_with_upload
    and_I_return_to_flow_page
    when_I_delete_confirmation_page
    when_I_visit_the_publishing_page
    then_I_should_be_on_the_publishing_page
    then_I_should_not_see_warning_both_text
    then_I_should_not_see_warning_cya_text
    then_I_should_see_warning_confirmation_text
  end

  scenario 'when username and password is too short' do
    when_I_visit_the_publishing_page
    then_I_should_be_on_the_publishing_page

    and_I_want_to_publish('Test')
    then_I_should_see_publish_to_test_modal
    then_username_and_password_should_be_the_default('dev')
    when_I_enter_invalid_username_and_password('dev', 'Test')
    then_I_should_see_an_error_message('dev', 'Test')

    and_I_cancel

    and_I_want_to_publish('Live')
    then_I_should_not_see_publish_to_test_modal
    then_username_and_password_should_be_selected('production')
    when_I_enter_invalid_username_and_password('live', 'Live')
    then_I_should_see_an_error_message('live', 'Live')
  end

  def when_I_visit_the_publishing_page
    sleep 0.5 # Allow time for the page to load
    editor.publishing_link.click
  end

  def and_I_want_to_publish(environment)
    editor.find('#publish-environments').find(:button, text: "Publish to #{environment}").click
  end

  def then_username_and_password_should_be_selected(environment)
    # defaults to requiring a username and password so the radio is pre selected

    # allow anyone
    expect(editor.find("#require_authentication_#{environment}_1", visible: false)).not_to be_checked
    # set username and password
    expect(editor.find("#require_authentication_#{environment}_2", visible: false)).to be_checked
  end

  def then_username_and_password_should_be_the_default(environment)
    # defaults to requiring a username and password so the radio is pre selected

    # allow anyone
    expect(page).to_not have_text(allow_anyone_text)
    # set username and password text
    expect(page).to_not have_text(username_and_password_text)
  end

  def when_I_enter_invalid_username_and_password(environment, button_environment)
    editor.find("#publish-form-#{environment} #publish_service_creation_username").set('foo')
    editor.find("#publish-form-#{environment} #publish_service_creation_password").set('bar')
    editor.find('.ui-dialog').find(:button, text: "Publish to #{button_environment}").click
  end

  def then_I_should_see_an_error_message(environment, button_environment)
    errors = editor.all("#publish-form-#{environment} .govuk-error-message").map(&:text)
    expect(errors).to match_array(username_and_password_errors)
  end

  def and_I_cancel
    editor.find('.ui-dialog').find(:button, text: 'Cancel').click
  end

  def then_I_should_be_on_the_publishing_page
    expect(editor.question_heading.first.text).to eq(I18n.t('publish.heading'))
    buttons_text = page.all(:css, 'input.fb-govuk-button', visible: false).map(&:value)
    expect(buttons_text).to include(I18n.t('publish.test.button'))
    expect(buttons_text).to include(I18n.t('publish.live.button'))
  end

  def then_I_should_not_see_warning_both_text
    expect(editor.text).to_not include(warning_both)
  end

  def then_I_should_not_see_warning_cya_text
    expect(editor.text).to_not include(warning_cya)
  end

  def then_I_should_not_see_warning_confirmation_text
    expect(editor.text).to_not include(warning_confirmation)
  end

  def then_I_should_see_warning_both_text
    expect(editor.text).to include(warning_both)
  end

  def then_I_should_see_warning_cya_text
    expect(editor.text).to include(warning_cya)
  end

  def then_I_should_see_warning_confirmation_text
    expect(editor.text).to include(warning_confirmation)
  end

  def then_I_should_see_publish_to_test_modal
    expect(editor.text).to include(modal_description)
  end

  def then_I_should_not_see_publish_to_test_modal
    expect(editor.text).to_not include(modal_description)
  end
end
