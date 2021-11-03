class PublishService < ApplicationRecord
  belongs_to :user

  STATUS = %w[
    queued
    pre_publishing
    publishing
    post_publishing
    completed
    unpublishing
    unpublished
  ].freeze

  validates :deployment_environment, :status, :service_id, presence: true
  validates :version_id, :user_id, presence: true
  validates :deployment_environment, inclusion: {
    in: Rails.application.config.deployment_environments
  }
  validates :status, inclusion: { in: STATUS }

  scope :completed, -> { where(status: 'completed') }
  scope :desc, -> { order(created_at: :desc) }

  def completed?
    status == 'completed'
  end

  def queued?
    status == 'queued'
  end

  def unpublishing?
    status == 'unpublishing'
  end

  def unpublished?
    status == 'unpublished'
  end

  def published?
    !(unpublishing? || unpublished?)
  end
end
