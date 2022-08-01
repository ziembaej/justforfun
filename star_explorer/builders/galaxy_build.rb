 Game::Builders.Galaxy do 
    ## High level galaxy build
    
    def initialize
        width = width(number)
        height = height(number)
    end 

    def initialize
    @zones = Array.new(width, height)
    end
    
    
    def locate(entity)
    puts "#{@entity} is currently in Zone #{@y_coord}:#{@y_coord}. 
    This is #{Zone.@federation} space, the risk of contact is #{Zone.@risk}"
    end
end