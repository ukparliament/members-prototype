require 'rails_helper'

describe PeopleController do
  let(:json) { JSON.parse(response.body) }
  let(:xml) { Nokogiri::XML(response.body) }
  let(:ttl) { RDF::NTriples::Reader.new(response.body) }

  describe "GET index" do

    context 'when the requested format is JSON' do
      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.json").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PEOPLE_HASH.to_json, :headers => {})
        get 'index',format: :json
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns only one person in the data' do
        expect(json['people'].length).to eq 5
      end

      it 'returns the correct id for the second person' do
        expect(json['people'][1]['id']).to eq '2'
      end
    end

    context 'when the requested format is XML' do
      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.xml").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PEOPLE_HASH.to_xml, :headers => {})
        get 'index',format: :xml
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/xml'
      end

      it 'returns only one person in the data' do
        expect(xml.xpath('//person').count).to eq 5
      end

      it 'returns the correct id for the person' do
        expect(xml.xpath('//person')[1].children.children[0].content).to eq '2'
      end
    end

    context 'when the requested format is TTL' do
      before(:each) do
        allow(subject).to receive(:get_data).with("#{MembersPrototype::Application.config.endpoint}/people").and_return(PEOPLE_GRAPH)
        get 'index', format: :ttl
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'text/turtle'
      end

      it 'returns only one person in the data' do
        expect(ttl.count).to eq 5
      end

      it 'returns the correct data for the first person' do
        expect(ttl.first).to eq PEOPLE_STATEMENTS[0]
      end
    end

    context 'when the requested format is HTML' do
      render_views

      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.json").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PEOPLE_HASH.to_json, :headers => {})

        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.ttl").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PEOPLE_TTL, :headers => {})

        allow(controller).to receive(:get_data).and_return({ graph: PEOPLE_TTL, json: PEOPLE_HASH.to_json })

        get 'index', format: :html
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'text/html'
      end

      it 'returns the correct data for the first person' do
        expect(response.body).to match(/<a href="\/people\/1">Member1<\/a>/)
      end

      it 'returns the correct json_ld in the response body' do
        expect(response.body).to match(/{"@id":"http:\/\/id.ukpds.org\/member\/1","http:\/\/schema.org\/name":"Member1"},{"@id":"http:\/\/id.ukpds.org\/member\/2","http:\/\/schema.org\/name":"Member2"},{"@id":"http:\/\/id.ukpds.org\/member\/3","http:\/\/schema.org\/name":"Member3"},{"@id":"http:\/\/id.ukpds.org\/member\/4","http:\/\/schema.org\/name":"Member4"},{"@id":"http:\/\/id.ukpds.org\/member\/5","http:\/\/schema.org\/name":"Member5"}/)
      end
    end

  end

  describe "GET show" do

    context 'when the requested format is JSON' do
      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people/1.json").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PERSON_ONE_HASH.to_json, :headers => {})
        get 'show', id: '1', format: :json
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns only one person in the data' do
        expect(json['people'].length).to eq 1
      end

      it 'returns the correct id for the person' do
        expect(json['people'][0]['id']).to eq '1'
      end
    end

    context 'when the requested format is XML' do
      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people/1.xml").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PERSON_ONE_HASH.to_xml, :headers => {})
        get 'show', id: '1', format: :xml
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/xml'
      end

      it 'returns only one person in the data' do
        expect(xml.xpath('//person').count).to eq 1
      end

      it 'returns the correct id for the person' do
        expect(xml.xpath('//person')[0].children.children[0].content).to eq '1'
      end
    end

    context 'when the requested format is TTL' do
      before(:each) do
        allow(subject).to receive(:get_data).with("#{MembersPrototype::Application.config.endpoint}/people/1").and_return(PERSON_ONE_GRAPH)
        get 'show', id: '1', format: :ttl
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'text/turtle'
      end

      it 'returns only one person in the data' do
        expect(ttl.count).to eq 1
      end

      it 'returns the correct data for the person' do
        expect(ttl.first).to eq PEOPLE_STATEMENTS[0]
      end
    end

    context 'when the requested format is HTML' do
      render_views

      before(:each) do
        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people/1.json").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PERSON_ONE_HASH.to_json, :headers => {})

        stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people/1.ttl").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => PERSON_ONE_TTL, :headers => {})

        get 'show', id: '1', format: :html
      end

      it 'returns OK response with correct format' do
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'text/html'
      end

      it 'returns the correct data for the person' do
        expect(response.body).to match(/<h1>Member1<\/h1>/)
        expect(response.body).not_to have_content('Member2')
      end

      it 'returns the correct json_ld in the response body' do
        expect(response.body).to match(/{"@id":"http:\/\/id.ukpds.org\/member\/1","http:\/\/schema.org\/name":"Member1"}/)
      end
    end
  end
end