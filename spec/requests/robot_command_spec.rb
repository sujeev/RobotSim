require 'rails_helper'

RSpec.describe "RobotCommands", type: :request do
  describe "POST /instruct" do
    it "place robot" do
      post robot_command_instruct_path, params: { command: 'PLACE 3,3,east'}
      expect(response).to have_http_status( :success)
      expect(response.body).to eq( Robot.first.to_json)
      expect( Robot.count).to eq( 1)
    end

    it "multiple instructions" do
      post robot_command_instruct_path, params: { command: 'PLACE 3,3,east'}
      post robot_command_instruct_path, params: { command: 'MOVE'}
      post robot_command_instruct_path, params: { command: 'LEFT'}
      post robot_command_instruct_path, params: { command: 'MOVE'}
      post robot_command_instruct_path, params: { command: 'REPORT'}
      expect(response).to have_http_status( :success)
      expect(response.body).to eq( '4,4,north')
    end

    it "No instruction" do
      post robot_command_instruct_path, params: { command: ''}
      expect(response).to have_http_status( :success)
      expect(response.body).to eq( 'No instruction')
    end

    it "Invalid instruction" do
      post robot_command_instruct_path, params: { command: 'ABC'}
      expect(response).to have_http_status( :success)
      expect(response.body).to eq( 'Invalid instruction')
    end
  end

end
