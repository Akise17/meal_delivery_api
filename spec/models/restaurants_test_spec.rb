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

    it 'it should Unprocessable Entity' do
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

  describe "GET | /restaurant/distance", type: :request do
    it 'it should Retive Data' do
      location = "-8.72864,115.251288"
      distance = 10
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/distance?location=#{location}&distance=#{distance}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      location = "-8.72864,115.251288"
      distance = 10
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/distance?location=#{location}&page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 

    it 'it should Unprocessable Entity' do
      location = "-8.72864"
      distance = 10
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/distance?location=#{location}&distance=#{distance}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(422)
    end
  end 

  describe "GET | /restaurant/time_range", type: :request do
    it 'it should Retive Data' do
      open_time = "12.00"
      close_time = "15.00"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/time_range?open_time=#{open_time}&close_time=#{close_time}&page=12&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      open_time = "12.00"
      close_time = "15.00"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/time_range?open_time=#{open_time}&page=12&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 
  end 

  describe "GET | /restaurant/price_range", type: :request do
    it 'it should Retive Data' do
      price_range = "10-50"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/price_range?price_range=#{price_range}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      price_range = "10-50"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/price_range?price_range=#{price_range}&page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 

    it 'it should Unprocessable Entity' do
      price_range = "10"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/price_range?price_range=#{price_range}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(422)
    end

    it 'it should Not Found' do
      price_range = "1-2"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/price_range?price_range=#{price_range}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404)
    end
  end 

  describe "GET | restaurant/search", type: :request do
    it 'it should Retive Relevance Data' do
      keyword = "kiwi berries"
      filter = "relevance"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/search?keyword=#{keyword}&filter=#{filter}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      menu = json[:data][:restaurants][0][:_source][:menus].find { |m| m[:name].match("Kiwi")}
      puts "Menu: #{menu}"
      expect(json[:meta][:status]).to eql(200)
      expect(menu[:name]).to include("Kiwi")
    end 

    it 'it should Retive Match Data' do
      keyword = "kiwi berries"
      filter = "best_match"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/search?keyword=#{keyword}&filter=#{filter}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      menu = json[:data][:restaurants][0][:_source][:menus].find { |m| m[:name].match("Kiwi")}
      puts "Menu: #{menu}"
      expect(json[:meta][:status]).to eql(200)
      expect(menu[:name]).to match("Kiwi Berries")
    end 
    
    it 'it should Bad Request' do
      keyword = "kiwi"
      filter = "relevance"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/search?keyword=#{keyword}&filter=#{filter}&page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 

    it 'it should Unprocessable Entity' do
      keyword = "10"
      filter = "relevancess"
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/search?keyword=#{keyword}&filter=#{filter}&page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(422)
    end
  end 

  describe "GET | /restaurant/top_restaurant", type: :request do
    it 'it should Retive Data' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/top_restaurant?page=1&per_page=10",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Bad Request' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/top_restaurant?page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400)
    end 
  end  

  describe "GET | /restaurant/transaction/:id", type: :request do
    it 'it should Retive Data' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/transaction/1",
        headers: header,
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200)
    end 
    
    it 'it should Not Found' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Basic #{token}"
      }
      get(
        "/api/v1/restaurant/transaction/10000",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404)
    end 
  end  
end
