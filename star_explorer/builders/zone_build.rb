Game::Build.Zone do 
    ## Set zone details within the galaxy
  
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
      #["NASA", "Neutral", "Romulan"].sample

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