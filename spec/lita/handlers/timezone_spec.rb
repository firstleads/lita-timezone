require "spec_helper"

describe Lita::Handlers::Timezone, lita_handler: true do

  # Routes
  it { is_expected.to route_command('time 12:00 in Brasilia').to(:time_in_other_timezone) }
  it { is_expected.to route_command('time 14:00 in Pacific Time (US & Canada)').to(:time_in_other_timezone) }

  it { is_expected.to route_command('time 09:00 from Brasilia to Pacific Time (US & Canada)').to(:time_between_locations) }
  it { is_expected.to route_command('time 09:00 from Pacific Time (US & Canada) to Brasilia').to(:time_between_locations) }

  let(:room) { Lita::Room.new(1, name: 'my-channel') }

  before { Lita.config.handlers.timezone.default_zone = 'Pacific Time (US & Canada)' }

  # Commands
  describe '#time_in_other_timezone' do
    context 'with valid parameters' do
      it 'replies with correct time in the specified timezone' do
        send_command('time 10:00 in Brasilia', from: room)
        expect(replies.last).to include '16:00'
      end
    end

    context 'when time is invalid' do
      it 'replies with a message telling to send a time in correct format' do
        send_command('time 25:01 in Brasilia', from: room)
        expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.invalid_time')
      end
    end

    context 'when specified TimeZone is invalid' do
      it 'replies with a message telling to send a valid Timezone' do
        send_command('time 10:00 in Xunda', from: room)
        expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.invalid_zone')
      end
    end

    context 'when result is in another day' do
      it 'replies with a message including the date' do
        send_command('time 10:00 in Beijing', from: room)
        date = Time.current.tomorrow.strftime('%F')
        expect(replies.last).to include "#{date} 02:00"
      end
    end

    context 'when time is now' do
      it 'replies with correct time in the specified timezone' do
        Timecop.freeze(Time.zone.parse('10:00')) do
          send_command('time now in Beijing', from: room)
          date = Time.current.tomorrow.strftime('%F')
          expect(replies.last).to include "#{date} 02:00"
        end
      end
    end
  end

  describe '#time_between_locations' do
    context 'with valid parameters' do
      it 'replies with correct time using "from" as base Timezone' do
        send_command('time 10:00 from Buenos Aires to Berlin', from: room)
        expect(replies.last).to include '14:00'
      end
    end

    context 'when time is invalid' do
      it 'replies with a message telling to send a time in correct format' do
        send_command('time 25:00 from Brasilia to Berlin', from: room)
        expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.invalid_time')
      end
    end

    context 'when first TimeZone is invalid' do
      it 'replies with a message telling to send a valid first Timezone' do
        send_command('time 10:00 from Xunda to Berlin', from: room)
        expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.invalid_first_zone')
      end
    end

    context 'when second TimeZone is invalid' do
      it 'replies with a message telling to send a valid second Timezone' do
        send_command('time 10:00 from Berlin to Xunda', from: room)
        expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.invalid_second_zone')
      end
    end

    context 'when result is in another day' do
      it 'replies with a message including the date' do
        send_command('time 15:00 from Brasilia to Beijing', from: room)
        date = Time.current.in_time_zone('Brasilia').tomorrow.strftime('%F')
        expect(replies.last).to include "#{date} 01:00"
      end
    end

    context 'when time is now' do
      it 'replies with correct time in the specified timezone' do
        Timecop.freeze(Time.zone.parse('16:00')) do
          send_command('time now from Brasilia to Beijing', from: room)
          date = Time.current.in_time_zone('Brasilia').tomorrow.strftime('%F')
          expect(replies.last).to include "#{date} 02:00"
        end
      end
    end
  end

  describe '#list_timezones' do
    context 'without filtering results' do
      it 'replies with all timezones' do
        send_command('available timezones', from: room)
        expect(replies.last.lines.size).to eq 745
      end
    end

    context 'filtering results' do
      context 'when filter matches something' do
        it 'replies with timezones that matches the filter' do
          send_command('available timezones containing Pacific', from: room)
          expect(replies.last.lines.size).to eq 47
        end
      end

      context 'when filter matches nothing' do
        it 'replies with a zero zones message' do
          send_command('available timezones containing Xunda', from: room)
          expect(replies.last).to eq I18n.t('lita.handlers.timezone.messages.no_zones_found', zone: 'Xunda')
        end
      end
    end
  end

end
