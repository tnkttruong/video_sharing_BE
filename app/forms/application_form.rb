# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Translation
  include ActiveModel::Validations::Callbacks

  def initialize(attributes = {})
    # Define dynamic attributes
    self.class.attribute_names.each do |attr|
      self.class.attribute attr.to_sym
    end
    super(attributes)
  end

  def valid!
    raise ExceptionError::UnprocessableEntity, error_messages unless valid?
  end

  private

  def error_messages
    errors.full_messages.first
  end

  def attribute_names
    []
  end
end
