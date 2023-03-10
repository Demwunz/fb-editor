class ConfirmationEmailSettingsUpdater
  attr_reader :confirmation_email_settings, :service

  CONFIG_WITHOUT_DEFAULTS = %w[
    CONFIRMATION_EMAIL_COMPONENT_ID
    CONFIRMATION_EMAIL_REPLY_TO
  ].freeze

  CONFIG_WITH_DEFAULTS = %w[
    CONFIRMATION_EMAIL_SUBJECT
    CONFIRMATION_EMAIL_BODY
  ].freeze

  def initialize(confirmation_email_settings:, service:)
    @confirmation_email_settings = confirmation_email_settings
    @service = service
  end

  def create_or_update!
    ActiveRecord::Base.transaction do
      save_submission_setting
      save_config_without_defaults
      save_config_with_defaults
    end
  end

  def save_submission_setting
    submission_setting = SubmissionSetting.find_or_initialize_by(
      service_id: service.service_id,
      deployment_environment: confirmation_email_settings.deployment_environment
    )
    submission_setting.send_confirmation_email = confirmation_email_settings.send_by_confirmation_email?
    submission_setting.save!
  end

  def save_config_without_defaults
    CONFIG_WITHOUT_DEFAULTS.each do |config|
      if params(config).present?
        create_or_update_the_service_configuration(config)
      else
        remove_the_service_configuration(config)
      end
    end
  end

  def save_config_with_defaults
    CONFIG_WITH_DEFAULTS.each do |config|
      if params(config).present?
        create_or_update_the_service_configuration(config)
      else
        create_or_update_the_service_configuration_adding_default_value(config)
      end
    end
  end

  def params(config)
    confirmation_email_settings.params(config.downcase.to_sym)
  end

  def create_or_update_the_service_configuration(config)
    setting = find_or_initialize_setting(config)
    setting.value = params(config)
    setting.save!
  end

  def create_or_update_the_service_configuration_adding_default_value(config)
    setting = find_or_initialize_setting(config)
    setting.value = confirmation_email_settings.default_value(config.downcase.to_sym)
    setting.save!
  end

  def remove_the_service_configuration(config)
    setting = find_or_initialize_setting(config)
    setting.destroy!
  end

  def find_or_initialize_setting(config)
    ServiceConfiguration.find_or_initialize_by(
      service_id: service.service_id,
      deployment_environment: confirmation_email_settings.deployment_environment,
      name: config
    )
  end
end
