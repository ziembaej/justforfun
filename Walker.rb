class Game
  attr_accessor :steps_taken

  MAX_STEPS = rand 10..1000

  puts "Welcome to the walking game.
  Enter the number of steps you'd like to take.
  Be careful not to wander too far though..."

  def initialize
    @steps_taken = 0
    start_game
  end

  def step(number)
    number = @number.to_i
    @steps_taken += number
  end

  def start_game
    while true
      puts "You have traveled #{@steps_taken} steps."
      steps_to_take = gets.to_i
      @steps_taken += steps_to_take
      if @steps_taken == MAX_STEPS
        puts 'You Have Traveled the Correct Distance!!! :-)'
        end_game
      elsif @steps_taken > MAX_STEPS
        puts 'Fool!! You have walked off the edge of the Earth and perished in the abyss of space.'
        end_game
      end
    end
  end
  
  def end_game
    puts "Play Again??"
    response = gets.chomp.to_s
    if response == 'Yes'
      puts "Challenge Accepted!"
      @steps_taken = 0
    else
      puts "Quitter"
      quit
    end
  end
end


Game.new

Game.step(5)

  