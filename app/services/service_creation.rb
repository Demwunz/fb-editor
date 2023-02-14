class ServiceCreation < Editor::Service
  def create
    return false if invalid?

    service = MetadataApiClient::Service.create(metadata)

    if service.errors?
      add_errors(service)
      false
    else
      assign_service_attributes(service)
      DefaultConfiguration.new(self).create
      true
    end
  end

  def assign_service_attributes(service)
    tap do
      self.service_id = service.id
    end
  end

  def metadata
    {
      metadata: NewServiceGenerator.new(
        service_name: service_name.strip,
        current_user:
      ).to_metadata
    }
  end
end
