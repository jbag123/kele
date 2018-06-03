require 'httparty'
require 'json'

module Roadmap  
  def get_roadmap(roadmap_id)
    response = self.class.get(base_uri("/roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(base_uri("/checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end

  private
    def base_uri(endpoint)
        "https://www.bloc.io/api/v1#{endpoint}"
    end
end
