module ApplicationHelper
  include MetadataPresenter::ApplicationHelper

  # Remove once new service flow page is finished
  def flow_thumbnail(page)
    type = if page.components.blank?
             page.type.gsub('page.', '')
           else
             page.components.first.type
           end
    thumbnail_link(uuid: page.uuid, thumbnail: type, title: page.title)
  end
  # Remove once new service flow page is finished

  def thumbnail_link(args)
    link_to edit_page_path(
      service.service_id, args[:uuid]
    ), class: "form-step_thumbnail #{args[:thumbnail]}", 'aria-hidden': true do
      concat image_pack_tag('thumbnails/thumbs_header.png', class: 'header', alt: '')
      concat tag.span("#{t('actions.edit')}: ", class: 'govuk-visually-hidden')
      concat tag.span(args[:title], class: 'text')
      concat image_pack_tag("thumbnails/thumbs_#{args[:thumbnail]}.jpg", class: 'body', alt: '')
    end
  end

  def strip_url(url)
    url.to_s.chomp('/').reverse.chomp('/').reverse.strip.downcase
  end

  # Remove once hotjar testing is complete
  def live_platform?
    ENV['PLATFORM_ENV'] == 'live'
  end
  # Remove once hotjar testing is complete
end
