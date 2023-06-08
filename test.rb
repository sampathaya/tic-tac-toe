require 'minitest/autorun'
require_relative 'tic-tac-toe'

describe 'Game' do
  before do
		@ttt = Game.new
  end

	describe 'initialize' do
		it 'initial values' do
			assert_equal @ttt.board, [1,2,3,4,5,6,7,8,9]
			assert_nil @ttt.depth
			assert_nil @ttt.opponent
		end

		it 'should print welcome notice when easy and against computer mode' do
			@ttt.depth = 0
			@ttt.opponent = 1
			assert_equal @ttt.welcome_notice.strip, 'You are going to play against Human with Easy level. Good Luck!'
		end

		it 'should print welcome notice when hard and against computer mode' do
			@ttt.depth = 1
			@ttt.opponent = 1
			assert_equal @ttt.welcome_notice.strip, 'You are going to play against Human with Hard level. Good Luck!'
		end
	end

	describe 'best move' do

		describe 'check available moves and best moves' do
			it 'should return available spaces and best move' do
				@ttt.board = ['O','O','O','O','O','O','O','O',9]
				assert_equal @ttt.calc_available_spaces, [8]
				assert_equal @ttt.get_best_move, 8
			end
		
			it 'should return available spaces and best move from 2 elements' do
				@ttt.board = ['O','O','O','O',5,'O','X','X',9]
				assert_equal @ttt.calc_available_spaces, [4,8]
				assert_includes [4,8], @ttt.get_best_move
		
				@ttt.board = [1,'O',3,'O',5,'O',7,'X',9]
				assert_equal [0,2,4,6,8], @ttt.calc_available_spaces
			end
		end

		describe 'find the best move' do
			before do
				@ttt.board = ['X','X',2,3,4,5,6,7,8]
				@ttt.opponent = 1
			end

			it 'should return the next best move  when easy mode' do
				@ttt.depth = 0
				assert_includes [2,3,4,5,6,7,8], @ttt.get_best_move
			end

			it 'should return the next best move  when hard mode' do
				@ttt.depth = 1
				assert_equal @ttt.get_best_move, 2
			end
		end
	end
end
