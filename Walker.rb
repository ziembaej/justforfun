class Game
  attr_accessor :steps_taken

  MAX_STEPS = 1000

  puts "Welcome to the walking game.
  Enter the number of steps you'd like to take.
  Be careful not to wander too far though..."

  def initializer
    @steps_taken = 0
    @max_steps = rand 10..MAX_STEPS
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
      if @steps_taken == @max_steps
        puts 'You Have Traveled the Correct Distance!!! :-)'
        end_game
      elsif @steps_taken > @max_steps
        puts 'Fool!! You have walked off the edge of the Earth and perished in the abyss of space.'
        puts @max_steps
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
      @max_steps = rand 10..MAX_STEPS
    else
      puts "Quitter"
      quit
    end
  end
end


Game.new

Game.step()

