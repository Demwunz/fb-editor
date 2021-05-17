require 'openssl'
require 'base64'

class DefaultConfiguration
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def create
    create_secret_and_token
    create_private_public_keys
  end

  private

  def create_secret_and_token
    Rails.application.config.deployment_environments.each do |deployment_environment|
      create_configuration(
        name: 'SERVICE_SECRET',
        value: SecureRandom.hex(16),
        deployment_environment: deployment_environment
      )

      create_configuration(
        name: 'SERVICE_TOKEN',
        value: SecureRandom.hex(16),
        deployment_environment: deployment_environment
      )
    end
  end

  def create_private_public_keys
    Rails.application.config.deployment_environments.each do |deployment_environment|
      key = PublicPrivateKey.new

      create_configuration(
        name: 'ENCODED_PRIVATE_KEY',
        value: key.private_key,
        deployment_environment: deployment_environment
      )

      create_configuration(
        name: 'ENCODED_PUBLIC_KEY',
        value: key.public_key,
        deployment_environment: deployment_environment
      )
    end
  end

  def create_configuration(name:, value:, deployment_environment:)
    ServiceConfiguration.create!(
      deployment_environment: deployment_environment,
      name: name,
      value: value,
      service_id: service.service_id
    )
  end
end
