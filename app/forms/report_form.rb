# frozen_string_literal: true

# Validates report form data
class ReportForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # gage_id tests doesn't pass with the follow
  # api: attribute :gage_id, :integer
  attr_accessor :gage_id
  
  attribute :start_date, :date
  attribute :end_date, :date

  validates_presence_of :start_date, :end_date, :gage_id
  validates_numericality_of :gage_id, only_integer: true
  validate :validate_start_date, :validate_end_date, :validate_gage_id

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

  def validate_gage_id
    return if gage_id.nil?

    return if Gage.find_by(id: gage_id)

    errors.add(
      :gage_id,
      :required
    )
  end
end
