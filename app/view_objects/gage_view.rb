# frozen_string_literal: true

# Gage view object
class GageView < SimpleDelegator
  # This code is commented out because is not used but is no deleted because could be used in
  # the future
  # def offset
  #   sec = super

  #   format('%+03d:%02d', sec / 3600, sec / 60 % 60)
  # end

  def last_waterflow_captured_at
    captured_at = super

    captured_at.nil? ? I18n.t('view_object.gage_view.missing_last_captured_at') : captured_at.to_s(:report)
  end
end
