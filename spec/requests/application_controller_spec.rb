require_relative '../spec_helper'

def app
  ApplicationController
end

describe ApplicationController do
  it 'responds with the JSON requested' do
    get 'api/v1/weather?lat=35&lon=139'

    expect(last_response.status).to eq(200)
    expect(last_response).to be_successful
    response = JSON.parse(last_response.body, symbolize_names: true)

    expect(response).to be_a(Hash)

    expect(response[:data][0][:attributes][:min_f]).to be_an(Float)

    expect(response[:data][0][:attributes][:max_f]).to be_an(Float)

    expect(response[:data][0][:attributes][:min_c]).to be_an(Float)

    expect(response[:data][0][:attributes][:max_c]).to be_an(Float)

    expect(response[:data][0][:attributes][:day_feels_like_f]).to be_an(Float)

    expect(response[:data][0][:attributes][:day_feels_like_c]).to be_an(Float)

    expect(response[:data][0][:attributes][:description]).to be_an(String)

    expect(response[:data][0][:attributes][:date]).to be_a(String)

    expect(response[:data][0][:attributes][:sky_coverage]).to be_a(Integer)
  end

  it 'it return an error json if invalid lon entered' do
    get 'api/v1/weather?lat=35&lon=ab'

    response = JSON.parse(last_response.body, symbolize_names: true)
    expect(response[:cod]).to eq('400')
    expect(response).to have_key(:message)
    expect(response[:message]).to eq('wrong longitude')
  end

  it 'it return an error json if invalid lat entered' do
    get 'api/v1/weather?lat=ab&lon=35'

    response = JSON.parse(last_response.body, symbolize_names: true)
    expect(response[:cod]).to eq('400')
    expect(response).to have_key(:message)
    expect(response[:message]).to eq('wrong latitude')
  end

  it 'it return an error json if invalid lat and lon entered' do
    get 'api/v1/weather?lat=ab&lon=ab'

    response = JSON.parse(last_response.body, symbolize_names: true)
    expect(response[:cod]).to eq('400')
    expect(response).to have_key(:message)
    expect(response[:message]).to eq('wrong latitude')
  end
end
