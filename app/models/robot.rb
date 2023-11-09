class Robot < ApplicationRecord

  validates :x_position, presence: true
  validates :y_position, presence: true
  enum :facing, { north: 0, east: 1, south: 2, west: 3 }, default: :north

  def self.instruct(command)
    return 'No instruction' if command == nil || command.length == 0
    command_grid = command.split(' ')
    case command_grid[0]
    when 'PLACE'
      set_robot(command_grid[1])
    when 'MOVE'
      move_robot
    when 'LEFT'
      rotate_robot('LEFT')
    when 'RIGHT'
      rotate_robot('RIGHT')
    when 'REPORT'
      report_robot
    else
      'Invalid instruction'
    end
  end

  private

  def self.set_robot(command)
    x, y, facing = command.split(',')
    x = x.to_i
    y = y.to_i
    if valid_position?(x, y)
      Robot.delete_all
      Robot.create(x_position: x, y_position: y, facing: facing)
    end
  end

  def self.move_robot
    robot = Robot.first
    return unless robot

    x, y = robot.x_position, robot.y_position
    case robot.facing
    when 'north'
      y += 1 if valid_position?(x, y + 1)
    when 'east'
      x += 1 if valid_position?(x + 1, y)
    when 'south'
      y -= 1 if valid_position?(x, y - 1)
    when 'west'
      x -= 1 if valid_position?(x - 1, y)
    end
    robot.update(x_position: x, y_position: y)
  end

  def self.rotate_robot(direction)
    robot = Robot.first
    return unless robot

    facings = %w(north east south west)
    index = facings.index(robot.facing)
    index += (direction == 'LEFT' ? -1 : 1)
    index %= 4
    robot.update(facing: facings[index])
  end

  def self.report_robot
    robot = Robot.first
    if robot
      "#{robot.x_position},#{robot.y_position},#{robot.facing}"
    else
      'Robot is not on the table'
    end
  end

  def self.valid_position?(x, y)
    x >= 0 && x < 5 && y >= 0 && y < 5
  end
end
