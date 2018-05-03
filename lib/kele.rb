require 'httparty'
require 'json'
class Kele
  include HTTParty
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
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    array = []
    response.each do |r|
      array.push(r)
    end
    return array
  end

  def get_roadmap(chain_id)
    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{chain_id}", headers: { "authorization" => @auth_token })
    ruby = JSON.parse(response.body)
    ruby['sections'].each do |s|
      puts s['name']
      s['checkpoints'].each do |c|
        puts c['name']
      end
    end
  end

  def get_checkpoint(id)
    response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{id}", headers: { "authorization" => @auth_token })
    ruby = JSON.parse(response.body)
    ruby['sections'][1].each do |s|
      puts s['name']
    end
  end
end
