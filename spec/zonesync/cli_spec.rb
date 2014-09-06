require 'rspec'
require 'zonesync/cli'

describe ZoneSync::CLI do
  describe '.execute' do
    let(:sample_zone_file_path) { './spec/fixtures/example.com' }
    let(:records) { ZoneSync::CLI.execute([sample_zone_file_path]) }

    context 'types' do
      subject { records.map(&:class) }

      it { is_expected.to eq [
        DNS::Zonefile::MX, DNS::Zonefile::MX, DNS::Zonefile::MX,
        DNS::Zonefile::A, DNS::Zonefile::AAAA,
        DNS::Zonefile::A, DNS::Zonefile::AAAA,
        DNS::Zonefile::CNAME, DNS::Zonefile::CNAME,
        DNS::Zonefile::A, DNS::Zonefile::A, DNS::Zonefile::A,
      ] }
    end

    context 'hosts' do
      subject { records.map(&:host) }

      it { is_expected.to eq [
        'example.com.', 'example.com.', 'example.com.',
        'example.com.', 'example.com.',
        'ns.example.com.', 'ns.example.com.',
        'www.example.com.', 'wwwtest.example.com.',
        'mail.example.com.', 'mail2.example.com.', 'mail3.example.com.',
      ] }
    end

    context 'addresses' do
      let(:method_for) {
        {
          DNS::Zonefile::A => :address,
          DNS::Zonefile::AAAA => :address,
          DNS::Zonefile::CNAME => :domainname,
          DNS::Zonefile::MX => :domainname,
        }
      }

      subject { records.map { |record| record.public_send(method_for[record.class]) } }

      it { is_expected.to eq [
        'mail.example.com.', 'mail2.example.com.', 'mail3.example.com.',
        '192.0.2.1', '2001:db8:10::1',
        '192.0.2.2', '2001:db8:10::2',
        'example.com.', 'www.example.com.',
        '192.0.2.3', '192.0.2.4', '192.0.2.5',
      ] }
    end
  end
end

