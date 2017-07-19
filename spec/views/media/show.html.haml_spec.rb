require 'rails_helper'

RSpec.describe 'media/show', vcr: false do
  context 'page title' do
    before :each do
      assign(:person,
        double(:person,
          display_name: 'Test Display Name',
          graph_id:     'XXXXXXXX'))

      assign(:image,
        double(:image,
          graph_id:     'XXXXXXXX'))

      render
    end

    it 'will render full name and title' do
      expect(rendered).to match(/Test Display Name/)
    end
  end

  context '@image' do
    context 'is nill' do
      before :each do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            graph_id:     'XXXXXXXX'))

        assign(:image,
          double(:image,
            graph_id:     nil))

        allow(Pugin::Feature::Bandiera).to receive(:show_list_images?).and_return(true)

        render
      end

      it 'will not render an image' do
        expect(rendered).to match(/highlight--box/)
      end
    end

    context 'is not nill' do
      before :each do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            graph_id:     'XXXXXXXX'))

        assign(:image,
          double(:image,
            graph_id:     'XXXXXXXX'))

        allow(Pugin::Feature::Bandiera).to receive(:show_list_images?).and_return(true)

        render
      end

      it 'will render an image' do
        expect(rendered).to match("#{ENV['IMAGE_SERVICE_URL']}/XXXXXXXX.jpeg")
      end
    end
  end

  context '@person' do
    before :each do
      assign(:person,
        double(:person,
          display_name: 'Test Display Name',
          graph_id:     'XXXXXXXX'))

      assign(:image,
        double(:image,
          graph_id:     'XXXXXXXX'))

      allow(Pugin::Feature::Bandiera).to receive(:show_list_images?).and_return(true)

      render
    end

    it 'will render link to person_path' do
      expect(rendered).to have_link('Test Display Name', href: person_path('XXXXXXXX'))
    end
  end
end
