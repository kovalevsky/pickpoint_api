require_relative '../spec_helper.rb'

include DummyData

describe ::PickpointApi::Session do
  before(:each) do
    @session = ::PickpointApi::Session.new(test: true)

    ::HttpMocking.set_next_response(LOGIN_SUCCESSFULL)
  end

  it 'can instatiate' do
    expect(@session).not_to be_nil
    expect(@session.test).to eq true
    expect(@session.state).to eq :new
  end

  describe '.login' do
    it 'should log-in' do
      @session.login('login', 'password')
      expect(@session.state).to eq :started
    end

    it 'should handle incorrect login' do
      ::HttpMocking.set_next_response(LOGIN_FAILED)
      expect { @session.login('login', 'password') }.to raise_error ::PickpointApi::Exceptions::ApiError
      expect(@session.state).to eq(:error)
    end
  end

  describe '.logout' do
    it 'should log out' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(LOGOUT_SUCCESSFULL)
      expect(@session.logout).to eq(true)
      expect(@session.state).to eq(:closed)
    end
  end

  describe '.create_sending' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(CREATE_SENDING_SUCCESSFULL)
      res = @session.create_sending(SAMPLE_SENDING_REQUEST)
      expect(res['CreatedSendings']).not_to be_empty
      expect(res['RejectedSendings']).to be_empty
    end
  end

  describe '.track_sending' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response({}.to_json)
      res = @session.track_sending('21121312')
    end
  end

  describe '.postamat_list' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response({}.to_json)
      @session.postamat_list
    end
  end

  describe '.make_label' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_label('12345')
    end

    it 'should handle multiple invoices' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_label(['123123','123213'])
    end

    it 'should handle api error' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_ERROR)
      expect{@session.make_label(['123123'])}.to raise_error PickpointApi::Exceptions::ApiError
    end
  end

  describe '.make_zlabel' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_zlabel('12345')
    end

    it 'should handle multiple invoices' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_zlabel(['123123','123213'])
    end

    it 'should handle api error' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_ERROR)
      expect{@session.make_label(['123123'])}.to raise_error PickpointApi::Exceptions::ApiError
    end
  end

  describe '.make_reestr' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_reestr('12345')
    end

    it 'should handle multiple invoices' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_SUCCESS)
      @session.make_reestr(['123123','123213'])

    end

    it 'should handle api error' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(PDF_ERROR)
      expect{@session.make_reestr(['123123'])}.to raise_error PickpointApi::Exceptions::ApiError
    end
  end

  describe '.city_list' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(CITY_LIST_SUCCESS)
      res = @session.city_list
      expect(res.count).to eq(2)
    end
  end

  describe '.get_states' do
    it 'should handle successfull request' do
      @session.login('login', 'password')
      ::HttpMocking.set_next_response(STATES_SUCCESS)
      res = @session.get_states
      expect(res.count).to eq(3)
    end
  end



end