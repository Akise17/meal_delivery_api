require 'rails_helper'

RSpec.describe "UserTest" do
  token = "MjpodW5ncnkxMjM0NTY3OA=="

  describe "GET | Authentication", type: :request do
    it 'it should Not Authorized' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic MjpodW5ncnkxMjM0NTY3OGE="
      }
      get(
        "/api/v1/user/transaction",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(401)
    end 

    it 'it should Not Found' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic token"
      }
      get(
        "/api/v1/user/transaction",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404)
    end 
  end 

  describe "GET | /user/top_user", type: :request do
    it 'it should Retive Data' do
      start_date = "2020-02-01"
      end_date = "2020-02-14"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/user/top_user?start_date=#{start_date}&end_date=#{end_date}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      start_date = "2020-02-01"
      end_date = "2020-02-14"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/user/top_user?start_date=#{start_date}&end_date=#{end_date}&page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 

    it 'it should Not Found' do
      start_date = "2020-02-01"
      end_date = "20"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/user/top_user?start_date=#{start_date}&end_date=#{end_date}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404)
    end
  end 

  describe "GET | /user/transaction", type: :request do
    it 'it should Retive Data' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/user/transaction",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
  end
  
  describe "POST | /order", type: :request do
    it 'it should Retive Data' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      body = {
        "menu_id": 1
      }
      post(
        "/api/v1/order",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(201)
    end 

    it 'it should Retive Data' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      body = {
        "menu_id": 10000000
      }
      post(
        "/api/v1/order",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404)
    end 
  end
end