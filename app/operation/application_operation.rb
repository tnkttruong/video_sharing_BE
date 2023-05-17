# frozen_string_literal: true

class ApplicationOperation

  attr_accessor :params, :current_user, :form

  def initialize(params, current_user = nil)
    @params       = params
    @current_user = current_user
  end

  def query_limit
    limit = params[:limit]&.to_i || Settings.query_limit
    limit = Settings.query_limit if limit > Settings.max_query_limit
    limit
  end

  def query_offset
    offset = params[:page].to_i - 1
    offset = 0 if offset < 0
    offset
  end
end
