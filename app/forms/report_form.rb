# frozen_string_literal: true

# Validates report form data
class ReportForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # river_id tests doesnt pass with the follow api: attribute :river_id, :integer
  attr_accessor :river_id
  attribute :start_date, :date
  attribute :end_date, :date

  validates_presence_of :start_date, :end_date, :river_id
  validates_numericality_of :river_id, only_integer: true
  validate :validate_start_date, :validate_end_date, :validate_river_id

  private

  def validate_start_date
    return if start_date.nil? || end_date.nil?

    return unless start_date > end_date

    errors.add(
      :start_date,
      :greater_than,
      attribute: I18n.t('activemodel.attributes.report_form.end_date')
    )
  end

  def validate_end_date
    return if start_date.nil? || end_date.nil?

    return unless end_date < start_date

    errors.add(
      :end_date,
      :smaller_than,
      attribute: I18n.t('activemodel.attributes.report_form.start_date')
    )
  end

  def validate_river_id
    return if river_id.nil?

    return if River.find_by(id: river_id)

    errors.add(
      :river_id,
      :required
    )
  end
end
