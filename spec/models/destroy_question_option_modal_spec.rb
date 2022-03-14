RSpec.describe DestroyQuestionOptionModal do
  subject(:destroy_question_option_modal) do
    described_class.new(
      service: service,
      page: page,
      question: question,
      option: option,
      label: 'option label'
    )
  end
  let(:service_metadata) { metadata_fixture(:branching_2) }

  before do
    @partial = destroy_question_option_modal.to_partial_path
  end

  describe '#to_partial_path' do
    let(:question) { page.components.first }

    context 'when there is a branch that relies on the option' do
      let(:page) { service.find_page_by_url('page-b') }
      let(:option) { question.items.first }

      it 'returns can not delete option modal' do
        expect(@partial).to eq('api/question_options/cannot_delete_modal')
      end
    end

    context 'when there is not a branch that depends on the option' do
      let(:page) { service.find_page_by_url('page-b') }
      let(:option) { question.items.last }

      it 'returns default delete option modal' do
        expect(@partial).to eq('api/question_options/destroy_message_modal')
      end
    end
  end
end
