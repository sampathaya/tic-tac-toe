#!/usr/bin/env ruby
require_relative 'winning_pattern'

class Game
  LEVELS = Hash[0, 'Easy', 1, 'Hard'].freeze
  OPPONENT = Hash[0, 'Computer', 1, 'Human'].freeze
  P1 = 'O'.freeze
  P2 = 'X'.freeze

  attr_accessor :board, :depth, :opponent, :winning_patterns

  def initialize
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @depth = nil
    @opponent = nil
    @winning_patterns = WinningPattern.new
  end

  def prepare_board
    @board.each_with_object('').with_index do |(item, board), index|
      idx = index + 1
      board << " #{item} | " if idx % 3 == 1
      board << "#{item} | " if idx % 3 == 2
      if (idx % 3).zero?
        board << item.to_s
        board << "\n===+===+===\n" if idx != @board.length
      end
    end
  end

  def print_board
    "#{prepare_board} \n\n"
  end

  def collect_depth
    until @depth
      puts "Do you want to play Easy or Hard level? \nEasy=0 \nHard=1 "
      input = gets.chomp.to_i
      @depth = (LEVELS.keys.include? input) ? input : nil
    end
  end

  def collect_opponent
    until @opponent
      puts "Do you want to play against the Computer or against another Human? \nComputer=0 \nHuman=1"
      input = gets.chomp.to_i
      @opponent = (OPPONENT.keys.include? input) ? input : nil
    end
  end

  def welcome_notice
    "\n\nYou are going to play against #{OPPONENT[@opponent]} with #{LEVELS[@depth]} level. Good Luck!\n\n"
  end

  def welcome
    puts "\nLet's Play Tic-Tac-Toe\n"
    collect_depth
    collect_opponent
    puts welcome_notice
  end

  def start_game
    welcome
    puts print_board

    until game_over?(@board) || tie(@board)
      player_input(1)
      puts print_board

      if player_win?(1)
        puts 'Congtratulations, Player 1 won'
        break
      end

      opponent == 0 ? computer_input : player_input(2)
      puts print_board

      if player_win?(2)
        puts 'Congtratulations, Player 2 won'
        break
      end
    end
    puts 'Game Draw - No winner' if tie(@board)
    puts print_board
  end

  def player_input(player)
    puts "\nPlayer #{player} turn. Please enter [1-9]:\n"
    spot = nil
    until spot
      spot = gets.chomp.to_i - 1
      if calc_available_spaces.include? spot
        @board[spot] = player == 1 ? P1 : P2
        break
      else
        puts "Sorry. Spot #{spot} taken or not possible. Please try again.\n"
        spot = nil
      end
    end
  end

  def computer_input
    @board[best_move] = P2
  end

  def calc_available_spaces
    @board.each_with_object([]).with_index { |(item, arr), index| arr << index unless %w[X O].include? item }
  end

  def generate_random_move(items)
    items[rand(0..items.count)]
  end

  def best_move
    available_spaces = calc_available_spaces
    return generate_random_move(available_spaces) if depth.zero?

    available_spaces.each do |spot|
      board = @board.dup
      board[spot] = P2

      return spot if game_over?(board)

      board[spot] = P1
      return spot if game_over?(board)

      board[spot] = @board[spot]
    end
    generate_random_move(available_spaces)
  end

  def game_over?(board)
    winning_patterns.load_possibilities(board).each do |spot1, spot2, spot3|
      return true if [spot1, spot2, spot3].uniq.length == 1
    end
    false
  end

  def player_win?(player)
    simbol = player == 1 ? 'O' : 'X'
    winning_patterns.load_possibilities(@board).each do |spot1, spot2, spot3|
      return true if [spot1, spot2, spot3].uniq.length == 1 && spot1 == simbol
    end
    false
  end

  def tie(board)
    board.all? { |s| %w[X O].include?(s) }
  end
end
