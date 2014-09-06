require 'dns/zonefile'

module ZoneSync
  class CLI
    class << self
      def execute(args)
        zone_file = File.read(File.expand_path(args.shift))
        zone = DNS::Zonefile.load(zone_file)

        zone.records.select { |record| record_types.include? record.class }
      end

      private

      def record_types
        [DNS::Zonefile::A, DNS::Zonefile::AAAA, DNS::Zonefile::CNAME, DNS::Zonefile::MX]
      end
    end
  end
end

