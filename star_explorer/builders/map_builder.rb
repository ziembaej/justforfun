# Build a Map

Game::Builder::Map.config do

    def galaxy_width(number)
        galaxy_width = @number
    end

    def galaxy_height(number)
        galaxy_height = @number
    end

    def grid_layout
        grid_layout = Array.new(@galaxy_width, @zone).map{|row| Array.new(@galaxy_height, @zone)}
        ## create a map grid based on the height and width inputs, where each cell is a "zone"
    end

    def set_zone()
        ##set the characteristics of each zone in a meaningful way?
    end    
        
end

