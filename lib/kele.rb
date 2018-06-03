require 'httparty'
require 'json'
require_relative './roadmap'
class Kele
  include HTTParty, Roadmap
  base_uri = 'https://www.bloc.io/api/v1'
  def initialize(email, password)
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { "email": email, "password": password })
    @auth_token = response["auth_token"]
    puts "Wrong credentials!!" if @auth_token.nil?
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token })
    stringResponse = response.to_s
    hash = JSON.parse(stringResponse)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_uri("/mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    array = []
    response.each do |r|
      array.push(r)
    end
    return array
  end
  
  private
    def base_uri(endpoint)
        "https://www.bloc.io/api/v1#{endpoint}"
    end

end
