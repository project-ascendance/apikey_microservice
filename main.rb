# frozen_string_literal: true
require 'bunny'
require './app/models/api_key'
require './app/models/user'
require './app/models/role'
require './app/repositories/role_repository'
require './app/repositories/user_repository'
require './app/repositories/api_key_repository'
require 'json'
class Main
  def initialize
    request_string = "apikey_exchange_requests"
    response_string = "apikey_exchange_responses"
    @connection = Bunny.new
    @connection.start until @connection.connected?
    @channel = @connection.create_channel

    request_exchange = @channel.direct(request_string)
    @channel.register_exchange(request_exchange)

    @apikey_answer_exchange = @channel.direct(response_string)
    @request_queue = @channel.queue("apikey_requests")
    @request_queue.bind(request_string)

    @incoming_to_be_processed = Queue.new


    @role_repo = RoleRepository.new
    @user_repo = UserRepository.new
    @apikey_repo = APIKeyRepository.new(@user_repo)
  end
  def run
    running = true
    @request_queue.subscribe do |delivery_info, properties, payload|
      @incoming_to_be_processed << JSON.parse(payload,symbolize_names: true)
    end
    while running
      while (request = @incoming_to_be_processed.pop)
        handle_request request
      end
    end
  end
  def handle_request(request)
    case request
    in {type: 'authenticate', return_route: return_route, apikey: apikey}
      if @apikey_repo.is_valid? apikey
        payload = {type: 'authenticate', apikey: apikey, result: "valid"}
      else
        payload = {type: 'authenticate', apikey: apikey, result: "invalid"}
      end
      @apikey_answer_exchange.publish(payload.to_json,routing_key: return_route)
    end
  end
  def add_testdata
    role = Role.new
    role.description = "user"
    apikey = APIKey.new
    user = User.new
    user.userid = 1
    apikey.user = user

    puts "API KEY: #{apikey.key}"

    @user_repo.create(user)
    @apikey_repo.create(apikey)
    @role_repo.create(role)
  end
end

main = Main.new
main.add_testdata
main.run


=begin
json structure, we use snak case instead of the normal camelcase.
{
  "type":"authenticate",
  "return_route":"test",
  "apikey":"9KIFj0zvnBIevMaMEGuhlYp0GevVqPrDOJgtvERY_PxyTf1dnHfiuhQBjuc6iFauduogUBPinAyOAKwyn79ujMui6C7bLNuxraEu5k8iNktLwrXEMGj0ISdFBjtwVPneu_IsaYgWjvnpMvpGMetNLUnFbfnSm99fYW2IaDktY1WNkvqGFsKbIGMU4v8Z4WMLSPDMoQHvUxG3KeL71yf_-ab_3ZYuaVZNubFF8gmdtxqWzC-7GOuVQPoiHBme5G0JaIFTVK64Ny8"
}
=end
