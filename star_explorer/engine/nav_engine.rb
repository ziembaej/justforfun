Game:Engine.navigate do

def travel_north(entity)
    entity.y_coord += 1 if entity.y_cood < GALAXY_HEIGHT
    end
    
    def travel_south(entity)
    entity.y_coord -= 1 if entity.y_coord > 0
    end
    
    def travel_east(entity)
    entity.x_coord += 1 if entity.x_coord < GALAXY_WIDTH
    end
    
    def travel_west(entity)
    entity.x_coord -= 1 if entity.x_coord > 0
    end
end