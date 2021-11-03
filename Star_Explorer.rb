class Ship ###separate into different ships later with unique initialized stats
  
  #Exterior Durability
  attr_accessor :shield_stength, :hull_strength
  #Engineering
  attr_accessor :engine_temperature, :fuel_level
  #Weapons
  attr_accessor :torpedo_count, :torpedo_power, :laser_power
  #Navigation
  attr_accessor :speed, :x_coord, :y_coord ##, :z_coord
 
  def initialize
    @shield_level = 50
    @hull_strength = 100
    @engine_temperature = 100
    @fuel_level = 50
    @torpedo_count = 10
    @torpedo_power = 25
    @laser_power = 3
  end 
  
  def fire_torpedo
    enemy.damage(@torpedo_power)
  end
  
  def fire_laser
    enemy.damage(@laser_power)
  end
  
  def damage(amount)
    if @shield_strength > 0
      @shield_strength -= amount
    else
      @hull_strength -= amount
  end
  
  def destroyed
    @hull_strength < 1
  end

  def repair_shield(amount)
    @shield_strength += amount
  end
  
  def repair_hull(amount)
    @hull_strength += amount
  end
  
  def print_status
    print "Shields at #{shield_level}"
    print "Hull Strength at #{hull_strength}"
  end
  
end


class Enemy ###separate into different ships later with unique initialized stats
  
  #Exterior Durability
  attr_accessor :shield_stength, :hull_strength
  #Engineering
  attr_accessor :engine_temperature, :fuel_level
  #Weapons
  attr_accessor :torpedo_count, :torpedo_power, :laser_power
  #Navigation
  attr_accessor :speed, :x_coord, :y_coord ##, :z_coord
 
  def initialize
    @shield_level = 30
    @hull_strength = 80
    @engine_temperature = 100
    @fuel_level = 50
    @torpedo_count = 6
    @torpedo_power = 26
    @laser_power = 2
  end 
  
  def damage(amount)
    if @shield_strength > 0
      @shield_strength -= amount
    else
      @hull_strength -= amount
  end
  
  def destroyed
    @hull_strength < 1
  end

  def repair_shield(amount)
    @shield_strength += amount
  end
  
  def repair_hull(amount)
    @hull_strength += amount
  end

end

class Item
  
  TYPES = [:shield_boost, :torpedo, :death_ray]
  
  attr_accessor :type
  
  def intialize
    @type = TYPES.sample
  end
  
  def interact(ship)
    case @type
    when :shield_boost
      puts "Boosting Shields Captain!"
      ship.repair_shield(25)
    when :torpedo
      puts "Loading extra Torpedos!"
      @torpedo_count += 1
    when :death_ray
      @laser_power = 1000
    end
  end
end

class Pilot ##Pilot doesn't do anything yet
  
  #Health
  attr_accessor :life
  #Skillz
  attr_accessor :pilot_skill_level, :targetting_skill, :navigation_skill
  
end

class Galaxy ##The full map
  
  GALAXY_WIDTH = 10
  GALAXY_HEIGHT = 10
  
  def initialize
    @zones = Array.new(GALAXY_WIDTH, Array.new(GALAXY_HEIGHT))
  end
  
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
  
  def locate(entity)
    puts "#{@entity} is currently in Zone #{@y_coord}:#{@y_coord}. 
    This is #{zone.@federation} space, the risk of contact is #{zone.@risk}"
  end
end

class Zone ##Segments of the map array
  
  attr_accessor :federation, :risk, :content
  
  def initialize
    @federation = "NASA"
    @risk = get_risk
    @content = get_content
  end
  
  def interact(ship)
    if @content
      @content.interact(ship)
      @content = nil
    end
  end
  
  def get_content
    [Enemy, Item].sample.new
  end   

  def get_federation
    ["NASA", "Neutral", "Romulan"].samle
  end
  
  def get_risk
    if @federation == "NASA"
      @risk = "No Risk"
    elsif @federation == "Neutral"
      @risk = "Medium Risk"
    elsif @federation == "Romulan"
      @risk = "High Risk"
    end
  end
  
end

class Game
  ACIONS = [
    :travel, :evade, :fight
  ]
  
  DIRECTIONS = [
    :north, :east, :south, :west
  ]
  
  def initialize
    @galaxy = Galaxy.new
    @ship = Ship.new
  
    start_game
  end
  
  
  
  

  

