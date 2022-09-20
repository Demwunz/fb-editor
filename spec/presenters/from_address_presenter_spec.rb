RSpec.describe FromAddressPresenter do
  subject(:from_address_presenter) { described_class.new(from_address) }
  let(:service_id) { SecureRandom.uuid }
  let(:from_address) { FromAddress.find_by(service_id: service_id) }

  describe '#message' do
    let(:expected_message) do
      {
        text: message,
        status: status
      }
    end

    context 'when from address is verified' do
      let(:message) { I18n.t('settings.from_address.messages.verified') }
      let(:status) { 'verified' }

      before do
        create(:from_address, :verified, service_id: service_id)
      end

      it 'returns the verified message' do
        expect(from_address_presenter.message).to eq(expected_message)
      end
    end

    context 'when from address is pending' do
      let(:message) { I18n.t('settings.from_address.messages.pending') }
      let(:status) { 'pending' }

      before do
        create(:from_address, :pending, service_id: service_id)
      end

      it 'returns the pending message' do
        expect(from_address_presenter.message).to eq(expected_message)
      end
    end

    context 'when from address is default' do
      let(:message) { I18n.t('settings.from_address.messages.default') }
      let(:status) { 'default' }

      before do
        create(:from_address, :default, service_id: service_id)
      end

      it 'returns the default message' do
        expect(from_address_presenter.message).to eq(expected_message)
      end
    end
  end
end
