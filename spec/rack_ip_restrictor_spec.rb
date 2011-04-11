require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rack::IpRestrictor do
  describe "#middleware" do
    subject { Rack::IpRestrictor.middleware }

    it { should respond_to :new }

    describe "#new" do
      subject { Rack::IpRestrictor.middleware.new([]) }
      it { should respond_to :call }
    end
  end

  context "#configure" do
    describe "#ips_for :test" do
      before do

        Rack::IpRestrictor.configure do
          ips_for :test do
            add '127.0.0.1'
            add '127.0.0.2/8'
          end
        end

      end

      it "sould be configured" do
        Rack::IpRestrictor.config.should_not be_nil
      end

      it "should have one ip groups" do
        Rack::IpRestrictor.config.ip_groups.size.should == 1
      end

      it "should have 2 ips" do
        Rack::IpRestrictor.config.ips_for(:test).ips.size.should == 2
      end

    end

    describe "#restrict '/secret'" do
      before do

        Rack::IpRestrictor.configure do
          respond_with [404, {'Content-Type' => 'text/html'}, "Not found"]

          ips_for :test do
            add '127.0.0.1'
            add '127.0.0.2/8'
          end

          restrict '/test'
          restrict /^\/test/
          restrict ['/test', '/test2']
        end

      end

      it "sould be configured" do
        Rack::IpRestrictor.config.should_not be_nil
      end
    end
  end
end
