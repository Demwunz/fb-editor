class SubmissionPagesPresenter
  include ActionView::Helpers
  include GovukLinkHelper
  attr_reader :messages, :service

  def initialize(service, messages)
    @service = service
    @messages = messages
  end

  def message
    @message ||= submitting_pages_not_present_message ||
      confirmation_page_not_present_message ||
      cya_page_not_present_message
  end

  def cya_and_confirmation_missing?
    !checkanswers_in_main_flow? &&
      !confirmation_in_main_flow?
  end

  def confirmation_in_main_flow?
    grid.page_uuids.include?(service.confirmation_page&.uuid)
  end

  private

  def link(pages_with_warnings)
    name_link = I18n.t("warnings.submission_pages.link.#{pages_with_warnings}")
    govuk_link_to(
      name_link,
      I18n.t('partials.header.user_guide_url')
    )
  end

  def adding_guide_link(pages_with_warnings)
    name_link = I18n.t("warnings.submission_pages.link.#{pages_with_warnings}")
    link = govuk_link_to(name_link, I18n.t('partials.header.user_guide_url'))
    warning_message.gsub('%{href}', link).html_safe
  end

  def submitting_pages_not_present_message
    if cya_and_confirmation_missing?
      messages[:both_pages].gsub('%{href}', link('both_pages')).html_safe
    end
  end

  def cya_page_not_present_message
    if !checkanswers_in_main_flow? && confirmation_in_main_flow?
      messages[:cya_page].gsub('%{href}', link('cya_page')).html_safe
    end
  end

  def confirmation_page_not_present_message
    if checkanswers_in_main_flow? && !confirmation_in_main_flow?
      messages[:confirmation_page].gsub('%{href}', link('confirmation_page')).html_safe
    end
  end

  def checkanswers_in_main_flow?
    grid.page_uuids.include?(service.checkanswers_page&.uuid)
  end

  def grid
    @grid ||= MetadataPresenter::Grid.new(service)
  end
end
