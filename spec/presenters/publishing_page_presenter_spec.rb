RSpec.describe PublishingPagePresenter do
  subject(:publishing_page_presenter) do
    described_class.new(
      service: service,
      deployment_environment: deployment_environment,
      service_autocomplete_items: service_autocomplete_items
    )
  end
  let(:deployment_environment) { 'dev' }
  let(:service_autocomplete_items) { double(messages: []) }

  describe '#from_address_presenter' do
    it 'returns an instance of a from address presenter' do
      expect(subject.from_address_presenter).to be_a FromAddressPresenter
    end
  end

  describe '#publish_creation' do
    it 'returns an instance of a publish creation' do
      expect(subject.publish_creation).to be_a PublishServiceCreation
    end
  end

  describe '#autocomplete_warning' do
    it 'returns an instance of a publish creation' do
      expect(subject.autocomplete_warning).to be_a AutocompleteItemsPresenter
    end
  end

  describe '#submission_warnings' do
    it 'returns an instance of submission warnings' do
      expect(subject.submission_warnings).to be_a SubmissionWarningsPresenter
    end

    context 'submission warning presenters' do
      let(:presenters) do
        [submission_pages_presenter, from_address_presenter]
      end
      let(:submission_pages_presenter) { double }
      let(:from_address_presenter) { double }

      before do
        allow(subject).to receive(:submission_pages_presenter).and_return(submission_pages_presenter)
        allow(subject).to receive(:from_address_presenter).and_return(from_address_presenter)
      end

      it 'returns the expected presenters' do
        expect(subject.submission_warnings.presenters).to match_array(presenters)
      end
    end
  end

  describe '#publish_button_disabled?' do
    RSpec.shared_examples 'a publishing button' do
      let(:deployment_environment) { 'production' }

      before do
        allow_any_instance_of(PublishServiceCreation).to receive(:no_service_output?).and_return(false)
      end

      context 'when there are submission warnings' do
        before do
          allow_any_instance_of(SubmissionWarningsPresenter).to receive(:messages).and_return(['Some messages'])
        end

        it 'returns truthy' do
          expect(subject.publish_button_disabled?).to be_truthy
        end
      end

      context 'when there are autocomplete warnings' do
        before do
          allow_any_instance_of(AutocompleteItemsPresenter).to receive(:messages).and_return(['Some messages'])
        end

        it 'returns truthy' do
          expect(subject.publish_button_disabled?).to be_truthy
        end
      end

      context 'when there are no submission or autocomplete warnings' do
        before do
          allow_any_instance_of(SubmissionWarningsPresenter).to receive(:messages).and_return([])
          allow_any_instance_of(AutocompleteItemsPresenter).to receive(:messages).and_return([])
        end

        it 'returns falsey' do
          # expect(subject.publish_button_disabled?).to be_falsey
        end
      end
    end

    context 'service output is disabled' do
      it 'returns falsey' do
        expect(subject.publish_button_disabled?).to be_falsey
      end
    end

    context 'service output is enabled' do
      it_behaves_like 'a publishing button'
    end

    context 'deployment environment is dev' do
      it 'returns falsey' do
        # expect(subject.publish_button_disabled?).to be_falsey
      end
    end

    context 'deployment environment is production' do
      # it_behaves_like 'a publishing button'
    end
  end
end
