require 'rails_helper'

RSpec.describe Robot, type: :model do
  describe 'validations' do
    it 'x_position absent' do
      robot = Robot.new( y_position: 1).save
      expect(robot).to be_falsey
    end

    it 'y_position absent' do
      robot = Robot.new( x_position: 1).save
      expect(robot).to be_falsey
    end

    it 'valid robot' do
      robot = Robot.new( x_position: 1, y_position: 1).save
      expect(robot).to be_truthy
    end
  end

  describe '#instruct' do
    context 'when placing robot' do
      context 'valid position' do
        it 'place robot' do
          expect(Robot.instruct('PLACE 1,1,east')).to eq( Robot.first)
        end
      end

      context 'invalid position' do
        it 'not place robot' do
          expect{ Robot.instruct('PLACE -1,1,east')}.not_to change{ Robot.count}.from(0)
        end
      end
    end

    context 'when moving robot' do

      context 'when valid move' do
        let!(:robot) { create( :robot) }
        it 'move robot' do
          expect{ Robot.instruct('MOVE')}.to change{ Robot.first.y_position}.from(0).to(1)
        end
      end

      context 'when invalid move' do
        let!(:robot) { create( :robot, facing: :west) }
        it 'move robot' do
          expect{ Robot.instruct('MOVE')}.not_to change{ Robot.first.y_position}.from(0)
        end
      end
    end

    context 'when turning robot' do
      let!(:robot) { create( :robot) }
      it 'move robot left' do
        expect{ Robot.instruct('LEFT')}.to change{ Robot.first.facing}.from('north').to('west')
      end

      it 'move robot right' do
        expect{ Robot.instruct('RIGHT')}.to change{ Robot.first.facing}.from('north').to('east')
      end
    end

    context 'when reporting robot' do
      let!(:robot) { create( :robot) }
      it 'move robot left' do
        expect( Robot.instruct('REPORT')).to eq("0,0,north")
      end
    end
  end
end
