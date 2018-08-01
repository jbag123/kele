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
    JSON.parse(stringResponse)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_uri("/mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    array = []
    response.each do |r|
      array.push(r)
    end
    return array
  end
  
  def get_messages(number = 0)
    if number == 0
      response = self.class.get(base_uri("/message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(base_uri("/message_threads?page=#{number}"), headers: { "authorization" => @auth_token })
    end
    @message = JSON.parse(response.body)
  end
  
  def create_message(sender,recipient_id,token,subject,stripped_text)
    params = "/messages?sender=#{sender}&recipient_id=#{recipient_id}&token=#{token}&subject=#{subject}&stripped-text=#{stripped_text}"
    puts params
    response = self.class.post(base_uri(params), headers: { "authorization" => @auth_token })
    puts response.body
  end
  
  def remaining_checkpoints(id)
    response = self.class.get(base_uri("/enrollment_chains/#{id}/checkpoints_remaining_in_section"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
  
  
  private
    def base_uri(endpoint)
        "https://www.bloc.io/api/v1#{endpoint}"
    end

end
