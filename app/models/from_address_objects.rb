module FromAddressObjects
  def from_address_creation
    @from_address_creation ||= FromAddressCreation.new(
      from_address: @from_address,
      email_service:
    )
  end

  def assign_from_address
    # initialize for those forms that were created before FromAddress records existed
    @from_address = FromAddress.find_or_initialize_by(service_id: service.service_id)
    if action_name == 'create'
      @from_address.assign_attributes(from_address_params)
    end
  end

  def email_service
    @email_service ||= if Rails.env.production?
                         EmailService::Adapters::AwsSesClient.new
                       else
                         EmailService::Adapters::Local.new
                       end
  end
end
