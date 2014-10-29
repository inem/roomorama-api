require "spec_helper"

describe "Roomorama API" do

  describe "Client" do
    let(:roomorama_client){ RoomoramaApi::Client.new }
    it "implement client" do
      expect( roomorama_client ).to be_instance_of( RoomoramaApi::Client )
    end

    describe "Class methods" do
      subject { RoomoramaApi::Client }
      it { is_expected.to respond_to(:configuration) }
      it { is_expected.to respond_to(:setup) }
    end

    describe "Public interface" do
      subject { RoomoramaApi::Client.new }
      it { is_expected.to respond_to(:auth_token) }
      it { is_expected.to respond_to(:create_property) }
      it { is_expected.to respond_to(:create_property_url) }
    end

    describe ".configuration" do
      let(:client){ RoomoramaApi::Client }
      it "responds to configuration" do
        expect( client ).to respond_to(:configuration)
      end
    end

    describe ".setup" do
      let(:client_klass){ RoomoramaApi::Client }
      it "alias to configuration method" do
        expect( client_klass ).to respond_to(:configuration)
        expect( client_klass.method(:setup).original_name ).to eql(:configuration)
      end

      let(:client) do
        client_klass.setup do |conf|
          conf.token = "token"
          conf.client_id = 7
          conf.client_secret = "secret"
        end
      end

      it "propertly setting up an Client object" do
        expect(client).to be_instance_of( client_klass )
        expect(client.config.token).to eql( "token" )
        expect(client.config.client_id).to eql( 7 )
        expect(client.config.client_secret).to eql( "secret" )
      end
    end

    describe "#auth_token" do
      let(:roomorama_client){ RoomoramaApi::Client.setup{|c| c.token = "fake_token_#313" }  }
      it "respond to auth_token" do
        expect( roomorama_client ).to respond_to(:auth_token)
      end

      it "return OAuth::Token class" do
        expect( roomorama_client.auth_token ).to be_instance_of( OAuth2::AccessToken )
      end

      it "assign access_token with value of token passed to the constructor" do
        expect( roomorama_client.auth_token.token ).to eql( "fake_token_#313" )
      end
    end

    describe "#create_property" do
      it "responds to create_room" do
        expect( roomorama_client ).to respond_to(:create_property)
      end

      it "recieve Status 200 for valid params" do
        allow( roomorama_client ).to receive(:create_room).and_return( {status: 200}  )
        expect( roomorama_client.create_room[:status] ).to eql( 200 )
      end
    end

    it "responds to create_room_url autogenerated method" do
      expect( roomorama_client ).to respond_to(:create_property_url)
    end

    it "builds create room url" do
      expect( roomorama_client.send(:create_property_url) ).to eql("https://api.staging.roomorama.com/v1.0/host/rooms.json")
    end

    it "raises an exception when resource is not supported" do
      expect{ roomorama_client.update_property_url }.to raise_exception(RoomoramaApi::EndpointNotImplemented)
    end

  end

end
