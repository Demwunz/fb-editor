class Api::ConditionalContentsController < ConditionalContentsController
  before_action :assign_conditional_content, only: %i[new_conditional]
  skip_before_action :authorised_access

  def new
    assign_conditional_content
    render 'new', layout: false
  end

  def create
    @conditional_content = ConditionalContent.new(conditional_content_params)
    content_visibility_creation = ContentVisibilityCreation.new(
      conditional_content: @conditional_content,
      latest_metadata: service_metadata
    )

    if content_visibility_creation.save
      redirect_to edit_conditional_content_path(service.service_id, content_visibility_creation.component_uuid)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def conditional_index
    params[:conditional_index] ? params[:conditional_index].to_i + 1 : nil
  end
  helper_method :conditional_index
  
  def new_conditional
    # respond_to do |format|
    #   format.turbo_stream { render 'new_condition'}
    #   format.html { render 'new_conditional', layout: false }
    # end
    render 'new_conditional', layout: false
  end

  def require_user!
    unless user_signed_in?
      render json: { message: 'Unauthorised' }, status: :unauthorized
    end
  end

  private

  def assign_conditional_content
    @conditional_content = ConditionalContent.new(conditional_content_attributes)
    @conditional_content.conditionals << ComponentConditional.new(expressions: [ComponentExpression.new])
  end

  def conditional_content_attributes
    {
      service:,
      previous_flow_uuid:,
      component_uuid: params[:component_uuid]
    }
  end

  def conditional_content_params
    params.require(:conditional_content).permit!.merge(conditional_content_attributes)
  end

  def previous_flow_uuid
    if params[:component_uuid].present?
      page_uuid = service.page_with_component(params[:component_uuid]).uuid
      previous_flow_obj = service.flow.select { |_k, v| v['next']['default'] == page_uuid }
      return previous_flow_obj.keys.first
    end

    params['conditional_content']['previous_flow_uuid']
  end

end
