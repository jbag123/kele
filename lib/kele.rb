require 'httparty'
require 'json'
class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  def initialize(email, password)
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { "email": email, "password": password })
    @auth_token = response["auth_token"]
    puts "Wrong credentials!!" if @auth_token.nil?
  end

  def get_me
    response = self.class.get('https://private-anon-38190ece44-blocapi.apiary-proxy.com/api/v1/users/me', headers: { "authorization" => @auth_token })
    stringResponse = response.to_s
    hash = JSON.parse(stringResponse)
  end
end
