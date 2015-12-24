module Lita
  module Handlers
    class Timezone < Handler
      config :default_zone, type: String, required: true

      route(/^time (?<time>([\d]{1,2}:[\d]{1,2})|now) in (?<zone1>.*)$/,
            :time_in_other_timezone, command: :true, help:
            { 'time 10:00 in Brasilia' => 'Time in Brasilia for 10:00 in the default_zone',
              'time now in Brasilia' => 'Time in Brasilia for current time' })

      route(/^time (?<time>([\d]{1,2}:[\d]{1,2})|now) from (?<zone1>.*) to (?<zone2>.*)$/,
            :time_between_locations, command: :true, help:
            { 'time 10:00 from Brasilia to Beijing' => 'Time in Beijing for 10:00 in Brasilia',
              'time now from Brasilia to Beijing' => 'Time in Beijing for current time in Brasilia'})

      route(/^available timezones( containing (?<filter>\w+))?$/,
            :list_timezones, command: :true, help:
            { 'available timezones' => 'All timezones names available for use',
              'available timezones containing Pacific' => 'Timezones that contains Pacific in the name'})

      def initialize(robot)
        super
        Time.zone = config.default_zone
        @all_zones = ActiveSupport::TimeZone.zones_map.keys + TZInfo::Timezone.all_identifiers
      end

      def time_in_other_timezone(response)
        requested_time = time_from_response(response)
        requested_zone = ActiveSupport::TimeZone[response.match_data[:zone1]]

        if requested_time.blank?
          response.reply t('messages.invalid_time')
        elsif requested_zone.blank?
          response.reply t('messages.invalid_zone')
        else
          time_in_new_time_zone = requested_time.in_time_zone(requested_zone)
          response.reply t('messages.response_in_zone', time: format_time(time_in_new_time_zone))
        end
      end

      def time_between_locations(response)
        requested_time = time_from_response(response)
        first_zone = ActiveSupport::TimeZone[response.match_data[:zone1]]
        second_zone = ActiveSupport::TimeZone[response.match_data[:zone2]]

        if requested_time.blank?
          response.reply t('messages.invalid_time')
        elsif first_zone.blank?
          response.reply t('messages.invalid_first_zone')
        elsif second_zone.blank?
          response.reply t('messages.invalid_second_zone')
        else
          original_time = first_zone.parse(requested_time.asctime)
          time_in_new_time_zone = original_time.in_time_zone(second_zone)

          response.reply t('messages.response_from_to_zone',
                            time: format_time(time_in_new_time_zone),
                            zone1: first_zone.name,
                            zone2: second_zone.name
                          )
        end
      end

      def list_timezones(response)
        zone_filter = (response.match_data[:filter] rescue nil)
        zones = zone_filter ? @all_zones.select { |name| name.include? zone_filter } : @all_zones

        if zones.empty?
          response.reply t('messages.no_zones_found', zone: zone_filter)
        else
          response.reply render_template('available_timezones', zones: zones)
        end
      end

      private

      def time_from_response(response)
        time = response.match_data[:time]
        return Time.current if time == 'now'

        parse_time(time)
      end

      def format_time(time_response)
        time_format = time_response.today? ? '%R' : '%F %R'
        time_response.strftime(time_format)
      end

      def parse_time(time, default = nil)
        Time.zone.parse(time)
      rescue ArgumentError
        default
      end

      Lita.register_handler(self)
    end
  end
end
