# frozen_string_literal: true

class ApplicationOperation

  attr_accessor :params, :current_user, :form

  def initialize(params, current_user = nil)
    @params       = params
    @current_user = current_user
  end
end
