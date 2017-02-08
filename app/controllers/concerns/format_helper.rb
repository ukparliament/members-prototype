require 'active_support'
require 'json'

module FormatHelper
  def format(data)
    respond_to do |format|
      format.html
      format.json { render request.format.to_sym => data[:serialized_data] }
      format.xml { render request.format.to_sym => JSON.parse(data[:serialized_data].to_json).to_xml }
    end
  end
end
