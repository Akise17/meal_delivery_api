require 'rails_helper'
require 'uri'
require 'net/http'

RSpec.describe "RestaurantsTest" do
  username = 2
  password = "hungry12345678"
  token = "MjpodW5ncnkxMjM0NTY3OA=="
  describe "GET | /restaurant/open", type: :request do
    it 'it should Retive Data' do
      datetime = "2021-11-09 05:00:00"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/open?datetime=#{datetime}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      datetime = "2021-11-09 05:00:00"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/open?datetime=#{datetime}&page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 

    it 'it should Date invalid' do
      datetime = "2021-11"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/open?datetime=#{datetime}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(422)
    end
  end 
end
