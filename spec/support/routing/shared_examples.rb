RSpec.shared_examples 'index route' do |controller|
  context 'index' do
    it "GET #{controller}#index" do
      expect(get: "/#{controller}").to route_to(
        controller: controller,
        action:     'index'
      )
    end
  end
end

# e.g. people#parties - /people/parties
RSpec.shared_examples 'top level routes' do |controller, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{action}").to route_to(
      controller: controller,
      action:     action
    )
  end
end

# e.g. people#show - people/581ade57-3805-4a4a-82c9-8d622cb352a4
RSpec.shared_examples 'nested routes with an id' do |controller, id, routes, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{id}/#{routes.join('/')}").to route_to(
      controller:                     controller,
      action:                         action,
      "#{controller.singularize}_id": id
    )
  end
end

# e.g. people#a_to_z_members - people/members/a-z
RSpec.shared_examples 'nested collection routes' do |controller, routes, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{routes.join('/')}").to route_to(
      controller: controller,
      action:     action
    )
  end
end

# e.g. people#members_letters - people/members/a-z/a
RSpec.shared_examples 'collection a_to_z route with a letter' do |controller, routes, action, letter|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{routes.join('/')}/#{letter}").to route_to(
      controller: controller,
      action:     action,
      letter:     letter
    )
  end
end

# e.g. parties#members_letters - parties/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/members/a-z/a
RSpec.shared_examples 'a_to_z route with an id and letter' do |controller, id, routes, action, letter|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{id}/#{routes.join('/')}/#{letter}").to route_to(
      controller:                     controller,
      action:                         action,
      letter:                         letter,
      "#{controller.singularize}_id": id
    )
  end
end

# e.g. postcodes#show - postcodes/SW1A-2AA
RSpec.shared_examples 'nested routes with a postcode' do |controller, postcode, routes, action|
  it "GET #{controller}##{action}" do
    expect(get: "/#{controller}/#{postcode}/#{routes.join('/')}").to route_to(
                                                                 controller:                     controller,
                                                                 action:                         action,
                                                                 "#{controller.singularize}":    postcode
                                                               )
  end
end
