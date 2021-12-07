require_relative '../spec_helper'

feature 'Edit confirmation pages' do
  let(:editor) { EditorApp.new }
  let(:service_name) { generate_service_name }
  let(:confirmation_heading) { 'Updated confirmation heading' }
  let(:confirmation_lede) { 'Updated confirmation lede' }
  let(:confirmation_body) { 'Updated confirmation body' }

  background do
    given_I_am_logged_in
    given_I_have_a_service
  end

  scenario 'updates all fields' do
    given_I_edit_a_confirmation_page
    and_I_change_the_page_heading(confirmation_heading)
    and_I_change_the_page_lede(confirmation_lede)
    and_I_change_the_page_body(confirmation_body)
    when_I_save_my_changes
    and_I_return_to_flow_page
    and_I_click_on_the_confirmation_page_three_dots
    then_I_should_only_see_three_options_on_page_menu
    and_I_click_edit_page
    then_I_should_see_the_confirmation_heading(confirmation_heading)
    then_I_should_see_the_confirmation_lede(confirmation_lede)
    then_I_should_see_the_confirmation_body(confirmation_body)
  end

  def and_I_change_the_page_body(body)
    when_I_change_editable_content(editor.page_body, content: body)
  end

  def then_I_should_see_the_confirmation_lede(lede)
    expect(editor.page_lede.text).to eq(lede)
  end

  def then_I_should_see_the_confirmation_body(body)
    expect(editor.page_body.text).to eq(body)
  end

  def and_I_click_on_the_confirmation_page_three_dots # confirmation page does not have 'img.body'
    sleep 0.5 # Arbitrary delay, possibly required due to focus issues
    page.find('.flow-thumbnail', text: confirmation_heading).hover
    editor.three_dots_button.click
  end

  def and_I_click_edit_page
    editor.edit_page_button.click
  end
end
