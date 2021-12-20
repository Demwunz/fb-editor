RSpec.describe PublishWarningPresenter do
  let(:presenter) do
    PublishWarningPresenter.new(service)
  end
  let(:warning_both_pages) do
    I18n.t('publish.warning.both_pages')
  end
  let(:warning_cya_page) do
    I18n.t('publish.warning.cya')
  end
  let(:warning_confirmation_page) do
    I18n.t('publish.warning.confirmation')
  end
  let(:delete_warning_both_pages) do
    I18n.t('pages.flow.delete_warning_both_pages')
  end
  let(:delete_warning_cya_page) do
    I18n.t('pages.flow.delete_warning_cya_page')
  end
  let(:delete_warning_confirmation_page) do
    I18n.t('pages.flow.delete_warning_confirmation_page')
  end
  let(:confirmation_uuid) { '778e364b-9a7f-4829-8eb2-510e08f156a3' }
  let(:checkanswers_uuid) { 'e337070b-f636-49a3-a65c-f506675265f0' }
  let(:checkanswers_page) do
    metadata['flow']['e337070b-f636-49a3-a65c-f506675265f0']
  end
  let(:arnold_incomplete_answers) do
    metadata['flow']['941137d7-a1da-43fd-994a-98a4f9ea6d46']
  end
  let(:arnold_right_answers) do
    metadata['flow']['56e80942-d0a4-405a-85cd-bd1b100013d6']
  end
  let(:arnold_wrong_answers) do
    metadata['flow']['6324cca4-7770-4765-89b9-1cdc41f49c8b']
  end

  describe 'check presence of cya and confirmation page' do
    context 'when there is both a check answers and confirmation page' do
      let(:service) { MetadataPresenter::Service.new(latest_metadata) }
      let(:latest_metadata) { metadata_fixture(:branching) }

      it 'returns nil' do
        expect(presenter.publish_warning_message).to be_nil
        expect(presenter.delete_warning_message).to be_nil
      end
    end

    context 'when there is no check answers or confirmation page' do
      let(:service) do
        MetadataPresenter::Service.new(metadata_fixture(:exit_only_service))
      end

      it 'returns the correct warning' do
        expect(presenter.publish_warning_message).to eq(warning_both_pages)
        expect(presenter.delete_warning_message).to eq(delete_warning_both_pages)
      end
    end
  end

  describe 'check presence of cya page' do
    let(:service) { MetadataPresenter::Service.new(latest_metadata) }
    let(:metadata) { metadata_fixture(:branching) }

    context 'when there is no check answers page' do
      let(:latest_metadata) do
        arnold_incomplete_answers['next']['default'] = confirmation_uuid
        arnold_right_answers['next']['default'] = confirmation_uuid
        arnold_wrong_answers['next']['default'] = confirmation_uuid
        metadata['flow'].delete(checkanswers_uuid)
        metadata['pages'] = metadata['pages'].reject do |page|
          page['_uuid'] == checkanswers_uuid
        end
        metadata
      end

      it 'returns the correct warning' do
        expect(presenter.publish_warning_message).to eq(warning_cya_page)
        expect(presenter.delete_warning_message).to eq(delete_warning_cya_page)
      end
    end

    context 'when check answers page is disconnected' do
      let(:latest_metadata) do
        arnold_incomplete_answers['next']['default'] = confirmation_uuid
        arnold_right_answers['next']['default'] = confirmation_uuid
        arnold_wrong_answers['next']['default'] = confirmation_uuid
        metadata
      end

      it 'returns the correct message' do
        expect(presenter.publish_warning_message).to eq(warning_cya_page)
        expect(presenter.delete_warning_message).to eq(delete_warning_cya_page)
      end
    end
  end

  describe 'check presence of confirmation page' do
    let(:service) { MetadataPresenter::Service.new(latest_metadata) }
    let(:metadata) { metadata_fixture(:branching) }

    context 'when there is no confirmation page' do
      let(:latest_metadata) do
        checkanswers_page['next']['default'] = '9e1ba77f-f1e5-42f4-b090-437aa9af7f73' # name
        metadata['flow'].delete(confirmation_uuid)
        metadata['pages'] = metadata['pages'].reject do |page|
          page['_uuid'] == confirmation_uuid
        end
        metadata
      end

      it 'returns the correct warning' do
        expect(presenter.publish_warning_message).to eq(warning_confirmation_page)
        expect(presenter.delete_warning_message).to eq(delete_warning_confirmation_page)
      end
    end

    context 'when confirmation page is disconnected' do
      let(:latest_metadata) do
        checkanswers_page['next']['default'] = ''
        metadata
      end

      it 'returns the correct warning' do
        expect(presenter.publish_warning_message).to eq(warning_confirmation_page)
        expect(presenter.delete_warning_message).to eq(delete_warning_confirmation_page)
      end
    end
  end
end
