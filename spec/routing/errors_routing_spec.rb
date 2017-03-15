require 'rails_helper'


RSpec.describe 'routes for Errors', :type => :routing do

  it 'routes /404 to the errors controller' do
     expect(:get => '/404').to route_to(:controller => 'errors', :action => 'not_found')
  end

  it 'routes /500 to the errors controller' do
    expect(:get => '/500').to route_to(:controller => 'errors', :action => 'internal_server_error')
  end

  it 'routes /204 to the errors controller' do
    expect(:get => '/204').to route_to(:controller => 'errors', :action => 'no_content')
  end

end
