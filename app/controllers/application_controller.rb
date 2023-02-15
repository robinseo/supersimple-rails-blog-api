class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |e|
    render status: 400, json: { message: "Record Invalid", detail: e.message }
  end
  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404, json: { message: "Record Not Found", detail: e.message }
  end
end
