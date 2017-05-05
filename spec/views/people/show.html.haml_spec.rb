require 'rails_helper'

RSpec.describe 'people/show', vcr: true do
  constituency_graph_id     = 'MtbjxRrE'
  house_of_commons_graph_id = 'KL2k1BGP'
  house_of_lords_graph_id   = 'm1EgVTLj'

  context 'header' do
    before do
      assign(:person,
        double(:person,
          display_name: 'Test Display Name',
          full_title:   'Test Title',
          full_name:    'Test Full Name',
          statuses:     { house_membership_status: ['Current MP'] },
          graph_id:     '7TX8ySd4'))

      assign(:house_incumbencies, [])
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id)))
      assign(:seat_incumbencies, [])
      assign(:most_recent_incumbency, nil)

      render
    end

    it 'will render the display name' do
      expect(rendered).to match(/Test Display Name/)
    end
  end

  context '@most_recent_incumbency' do
    before do
      assign(:person,
        double(:person,
          display_name: 'Test Display Name',
          full_title:   'Test Title',
          full_name:    'Test Full Name',
          statuses:     { house_membership_status: ['Current MP'] },
          graph_id:     '7TX8ySd4'))

      assign(:house_incumbencies, [])
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id)))
      assign(:seat_incumbencies, [])
    end

    context 'nil' do
      before do
        assign(:most_recent_incumbency, nil)
        render
      end

      it 'will render full name and title' do
        expect(rendered).to match(/Test Full Name/)
      end

      it 'will render title' do
        expect(rendered).to match(/Test Title/)
      end
    end

    context 'is not nil' do
      context 'house is House of Commons' do
        before do
          assign(:most_recent_incumbency,
            double(:most_recent_incumbency,
              house: double(:house, name: 'House of Commons')))
          render
        end

        it 'will not render full name and title' do
          expect(rendered).not_to match(/Test Title/)
        end
      end

      context 'house is House of Lords' do
        before do
          assign(:most_recent_incumbency,
            double(:most_recent_incumbency,
              house: double(:house, name: 'House of Lords')))
          render
        end

        it 'will render full name and title' do
          expect(rendered).to match(/Test Title/)
        end
      end
    end
  end

  context 'persons status' do
    before do
      assign(:house_incumbencies, [])
      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id)))
      assign(:seat_incumbencies, [])
      assign(:most_recent_incumbency, nil)
    end

    context 'house membership status is empty' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: [] },
            graph_id:     '7TX8ySd4'))
        render
      end

      it 'will not render status info' do
        expect(rendered).not_to match(/MP for/)
      end

      it 'will render link to house_members_current_a_z_letter_path' do
        expect(rendered).not_to have_link('All current MPs', href: house_members_current_a_z_letter_path(house_of_commons_graph_id, 'a'))
      end
    end

    context 'person is an MP' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Current MP'] },
            graph_id:     '7TX8ySd4'))
        render
      end

      it 'will not render status info' do
        expect(rendered).to match(/MP for/)
      end

      it 'will render link to constituency' do
        expect(rendered).to have_link('Aberavon', href: constituency_path(constituency_graph_id))
      end

      context 'person is former Lord' do
        before do
          assign(:person,
            double(:person,
              display_name: 'Test Display Name',
              full_title:   'Test Title',
              full_name:    'Test Full Name',
              statuses:     { house_membership_status: ['Current MP', 'Former Lord'] }))
          render
        end

        it 'will render link to house_members_current_a_z_letter_path' do
          expect(rendered).to have_link('All current MPs', href: house_members_current_a_z_letter_path(house_of_commons_graph_id, 'a'))
        end

        it 'will render link to house_members_a_z_letter_path' do
          expect(rendered).to have_link('All Lords', href: house_members_a_z_letter_path(house_of_lords_graph_id, 'a'))
        end
      end

      context 'person is not a former Lord' do
        it 'will not render link to house_members_a_z_letter_path' do
          expect(rendered).not_to have_link('All Lords', href: house_members_a_z_letter_path(house_of_lords_graph_id, 'a'))
        end
      end
    end

    context 'person is a Lord' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Lord', 'Test Membership'] }))
        render
      end

      it 'will render statuses' do
        expect(rendered).to match(/Lord and Test Membership/)
      end

      it 'will render link to house_members_current_a_z_letter_path' do
        expect(rendered).to have_link('All current Lords', href: house_members_current_a_z_letter_path(house_of_lords_graph_id, 'a'))
      end

      context 'person is a former MP' do
        before do
          assign(:person,
            double(:person,
              display_name: 'Test Display Name',
              full_title:   'Test Title',
              full_name:    'Test Full Name',
              statuses:     { house_membership_status: ['Former MP', 'Lord'] },
              graph_id:     '7TX8ySd4'))
          render
        end

        it 'will render statuses' do
          expect(rendered).to match(/Former MP and Lord/)
        end

        it 'will render link to house_members_current_a_z_letter_path' do
          expect(rendered).to have_link('All current Lords', href: house_members_current_a_z_letter_path(house_of_lords_graph_id, 'a'))
        end

        it 'will render link to house_members_a_z_letter_path' do
          expect(rendered).to have_link('All MPs', href: house_members_a_z_letter_path(house_of_commons_graph_id, 'a'))
        end
      end
    end

    context 'person is not a current MP or current Lord' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Test Membership'] },
            graph_id:     '7TX8ySd4'))
        render
      end

      it 'will render statuses' do
        expect(rendered).to match(/Test Membership/)
      end

      it 'will render link to house_members_a_z_letter_path' do
        expect(rendered).to have_link('All current and former Lords', href: house_members_a_z_letter_path(house_of_lords_graph_id, 'a'))
      end

      context 'person is a former MP' do
        before do
          assign(:person,
            double(:person,
              display_name: 'Test Display Name',
              full_title:   'Test Title',
              full_name:    'Test Full Name',
              statuses:     { house_membership_status: ['Former MP'] },
              graph_id:     '7TX8ySd4'))
          render
        end

        it 'will render statuses' do
          expect(rendered).to match(/Former MP/)
        end

        it 'will render link to house_members_a_z_letter_path' do
          expect(rendered).to have_link('All current and former MPs', href: house_members_a_z_letter_path(house_of_commons_graph_id, 'a'))
        end

        context 'person is a former Lord' do
          before do
            assign(:person,
              double(:person,
                display_name: 'Test Display Name',
                full_title:   'Test Title',
                full_name:    'Test Full Name',
                statuses:     { house_membership_status: ['Former MP', 'Former Lord'] },
                graph_id:     '7TX8ySd4'))
            render
          end

          it 'will render statuses' do
            expect(rendered).to match(/Former MP and Former Lord/)
          end

          it 'will render link to house_members_a_z_letter_path for MPs' do
            expect(rendered).to have_link('All current and former MPs', href: house_members_a_z_letter_path(house_of_commons_graph_id, 'a'))
          end

          it 'will render link to house_members_a_z_letter_path for Lords' do
            expect(rendered).to have_link('All current and former Lords', href: house_members_a_z_letter_path(house_of_lords_graph_id, 'a'))
          end
        end
      end
    end

    context 'current incumbency and current party membership' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Current MP'] },
            graph_id:     '7TX8ySd4'))

        assign(:current_incumbency,
          double(:current_incumbency,
            constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id), contact_points: []))

        assign(:current_party_membership,
          double(:current_party_membership, party: double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')))

        render
      end

      it 'will render link to party_path' do
        expect(rendered).to have_link('Conservative', href: party_path('jF43Jxoc'))
      end
    end
  end

  context '@current_incumbency and @current_party_membership are present' do
    before do
      assign(:house_incumbencies, [])
      assign(:seat_incumbencies, [])
      assign(:most_recent_incumbency, nil)
      assign(:current_party_membership, double(:current_party_membership, party: double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')))
    end

    context 'postcode' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Current MP'] },
            graph_id:     '7TX8ySd4'))

        assign(:current_incumbency,
          double(:current_incumbency,
            contact_points: [],
            constituency:   double(:constituency,
              name:     'Aberavon',
              graph_id: constituency_graph_id)))
      end

      context 'postcode is not assigned' do
        it 'will render postcode lookup' do
          render
          expect(response).to render_template(partial: 'postcodes/_postcode_lookup')
        end
      end

      context 'postcode is assigned' do
        before do
          assign(:postcode, 'SW1A 0AA')
        end

        context 'postcode constituency is correct' do
          before do
            assign(:postcode_constituency, double(:postcode_constituency, correct?: true, members: [double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')]))
            render
          end

          it 'will render correct name' do
            expect(rendered).to match(/Test Display Name is the MP for the postcode entered/)
          end
        end

        context 'postcode constituency is not correct' do
          before do
            assign(:postcode_constituency, double(:postcode_constituency, correct?: false, members: [double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')]))
            render
          end

          it 'will render incorrect mp' do
            expect(rendered).to match(/Test Display Name is not the MP for the postcode entered/)
          end

          it 'will render link to person_path' do
            expect(rendered).to have_link('Test Display Name', href: person_path('7TX8ySd4'))
          end
        end
      end
    end

    context 'person is a current MP' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Current MP'] },
            graph_id:     '7TX8ySd4'))
      end

      context '@current_incumbency.contact_points is empty' do
        before do
          assign(:current_incumbency,
            double(:current_incumbency,
              contact_points: [],
              constituency:   double(:constituency,
                name:     'Aberavon',
                graph_id: constituency_graph_id)))
          render
        end

        it 'will not render contact points' do
          expect(rendered).to match(/Empty Contact Details/)
        end
      end

      context '@current_incumbency.contact_points is not empty' do
        before do
          assign(:current_incumbency,
            double(:current_incumbency,
              constituency:   double(:constituency,
                name:     'Aberavon',
                graph_id: constituency_graph_id),
              contact_points: [
                double(:contact_point,
                  email:            'testemail@test.com',
                  phone_number:     '07700000000',
                  postal_addresses: [
                    double(:postal_address, full_address: 'Full Test Address')
                  ])
              ]))
          render
        end

        context 'contact details' do
          it 'will render email' do
            expect(rendered).to match(/testemail@test.com/)
          end

          context 'phone number' do
            it 'will render phone number' do
              expect(rendered).to match(/07700000000/)
            end

            before do
              assign(:current_incumbency,
                double(:current_incumbency,
                  constituency:   double(:constituency,
                    name:     'Aberavon',
                    graph_id: constituency_graph_id),
                  contact_points: [
                    double(:contact_point,
                      email:            'testemail@test.com',
                      phone_number:     '  07700000 001 ',
                      postal_addresses: [
                        double(:postal_address,
                          full_address: 'Full Test Address')
                      ])
                  ]))
              render
            end

            it 'will remove whitespace' do
              expect(rendered).to match(/07700000001/)
            end
          end

          it 'will render postal address' do
            expect(rendered).to match(/Full Test Address/)
          end

          it 'will not render a line break' do
            expect(rendered).not_to match(/line-break-heavy/)
          end
        end

        context 'more than 1 contact point' do
          before do
            assign(:current_incumbency,
              double(:current_incumbency,
                constituency:   double(:constituency,
                  name:     'Aberavon',
                  graph_id: constituency_graph_id),
                contact_points: [
                  double(:contact_point,
                    email:            'testemail@test.com',
                    phone_number:     '  07700000 001 ',
                    postal_addresses: [
                      double(:postal_address,
                        full_address: 'Full Test Address')
                    ]),
                  double(:contact_point,
                    email:            'testemail2@test.com',
                    phone_number:     '  0770000000',
                    postal_addresses: [
                      double(:postal_address,
                        full_address: 'Full Test Address 2')
                    ])
                ]))
            render
          end

          it 'will render line break after last contact point' do
            expect(rendered).to match(/.line-break--sm/)
          end
        end
      end
    end

    context 'person is a Lord' do
      before do
        assign(:person,
          double(:person,
            display_name: 'Test Display Name',
            full_title:   'Test Title',
            full_name:    'Test Full Name',
            statuses:     { house_membership_status: ['Member of the House of Lords'] },
            graph_id:     '7TX8ySd4'))

        assign(:current_incumbency,
          double(:current_incumbency,
            contact_points: [],
            constituency:   double(:constituency,
              name:     'Aberavon',
              graph_id: constituency_graph_id)))

        render
      end

      context 'no contact details' do
        it 'will render no contact details' do
          expect(rendered).to match(/Empty Contact Details/)
        end
      end
    end
  end

  context '@house_incumbencies or @seat_incumbencies are present' do
    before do
      assign(:person,
        double(:person,
          display_name: 'Test Display Name',
          full_title:   'Test Title',
          full_name:    'Test Full Name',
          statuses:     { house_membership_status: ['Lord'] },
          graph_id:     '7TX8ySd4'))
      assign(:most_recent_incumbency, nil)
      assign(:current_party_membership,
        double(:current_party_membership,
          party: double(:party,
            name: 'Conservative', graph_id: 'jF43Jxoc')))
    end

    context '@house_incumbencies' do
      before do
        assign(:seat_incumbencies, [])
        assign(:house_incumbencies, [
                 double(:house_incumbency,
                   start_date: Time.zone.now - 1.month,
                   end_date:   nil,
                   current?:   true),
                 double(:house_incumbency,
                   start_date: Time.zone.now - 2.months,
                   end_date:   Time.zone.now - 1.week,
                   current?:   false)
               ])
        render
      end

      it 'will render the correct sub-header' do
        expect(rendered).to match(/Member of the House of Lords/)
      end

      context 'incumbency is current' do
        it 'will render start date to present' do
          expect(rendered).to match((Time.zone.now - 1.month).strftime('%-e %b %Y'))
        end

        it 'will render present status' do
          expect(rendered).to match('to present')
        end
      end

      context 'incumbency is not current' do
        it 'will render start date' do
          expect(rendered).to match((Time.zone.now - 2.month).strftime('%-e %b %Y'))
        end

        it 'will render end date' do
          expect(rendered).to match("to #{(Time.zone.now - 1.week).strftime('%-e %b %Y')}")
        end
      end
    end

    context '@seat_incumbencies' do
      before do
        assign(:house_incumbencies, [])
        assign(:seat_incumbencies, [
                 double(:seat_incumbency,
                   start_date:   Time.zone.now - 1.month,
                   end_date:     nil,
                   current?:     true,
                   constituency: double(:constituency,
                     name:       'Aberavon',
                     graph_id:   constituency_graph_id,
                     start_date: Time.zone.now - 1.month)),
                 double(:seat_incumbency,
                   start_date:   Time.zone.now - 2.months,
                   end_date:     Time.zone.now - 1.week,
                   current?:     false,
                   constituency: double(:constituency,
                     name:       'Aberconwy',
                     graph_id:   constituency_graph_id,
                     start_date: Time.zone.now - 1.month))
               ])

        render
      end

      it 'will render the correct sub-header' do
        expect(rendered).to match(/Member of the House of Commons/)
      end

      it 'will render link to first constituency_path' do
        expect(rendered).to have_link('Aberavon', href: constituency_path(constituency_graph_id))
      end

      it 'will render link to last constituency_path' do
        expect(rendered).to have_link('Aberconwy', href: constituency_path(constituency_graph_id))
      end

      it 'will render the first incumbencies start date' do
        expect(rendered).to match((Time.zone.now - 1.month).strftime('%-e %b %Y'))
      end

      it 'will render the last incumbencies start date' do
        expect(rendered).to match((Time.zone.now - 2.months).strftime('%-e %b %Y'))
      end
    end
  end
end
