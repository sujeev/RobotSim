class RobotCommandController < ApplicationController
  
  def instruct
    command_response = Robot.instruct( params[:command])
    render json: command_response
  end
end
