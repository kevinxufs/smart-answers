class SpaceportFlow < SmartAnswer::Flow
  def define
    name 'spaceport'
    content_id "<SecureRandom.uuid>"
    status :draft





    radio :space_activity do
      option :spaceport
      option :range_control
      option :launch_and_return
      option :orbital_space_object

      on_response do |response|
        self.calculator = SmartAnswer::Calculators::SpaceportCalculator.new
        calculator.space_activity = response
      end

      next_node do |response|
        if response == "spaceport"
          question :spaceport_location
        elsif response == "range_control"
          question :who_rc_operate
        elsif response == "launch_and_return"
          question :territorial_waters
        else
          question :sat_orbit
        end
      end
    end







# spaceport flow

    radio :spaceport_location do
      option :england
      option :scotland
      option :wales
      option :northern_ireland

      next_node do
        question :horizontal_vertical
      end
    end

    radio :horizontal_vertical do
      option :horizontal
      option :vertical

      next_node do |response|
        if response == "horizontal"
          question :caa_aerodrome
        else
          question :sea_vessel
        end
      end
    end

    radio :caa_aerodrome do
      option :yes
      option :no

      next_node do
        question :sea_vessel
      end
    end

    radio :sea_vessel do
      option :yes
      option :no

      next_node do
        question :spaceport_fuel
      end
    end

    radio :spaceport_fuel do
      option :yes
      option :no

      next_node do
        outcome :outcome_1
      end
    end

# Range control flow

radio :who_rc_operate do
  option :own_launch
  option :third_party
  option :both

  next_node do
    question :rc_sea
  end
end 

radio :rc_sea do
  option :yes
  option :no

  next_node do |response|
    if response == "yes"
      question :rc_nation
    else
      question :outcome_1
    end
  end
end

radio :rc_nation do
  option :england
  option :scotland
  option :wales
  option :northern_ireland

  next_node do
    question :outcome_1
  end
end

# launch and return flow


radio :territorial_waters do
  option :yes
  option :no

  on_response do |response|
    calculator.territorial_waters = response
  end


  next_node do
    question :large_rocket
  end
end

radio :large_rocket do
  option :yes
  option :no


  on_response do |response|
    calculator.large_rocket = response
  end
  next_node do
    question :foreign_airspace
  end
end

radio :foreign_airspace do
  option :yes
  option :no
  on_response do |response|
    calculator.foreign_airspace = response
  end

  next_node do
    question :marine_return
  end
end

radio :marine_return do
  option :yes
  option :no
  on_response do |response|
    calculator.marine_return = response
  end

  next_node do
    outcome :outcome_1
  end
end


# satellite

    radio :sat_orbit do
      option :yes
      option :no

      next_node do |response|
        if response == "yes"
          question :sat_function
        else
          question :sat_loc
        end
      end
    end

    checkbox_question :sat_function do
      option :aero
      option :bus_radio
      option :earth_station
      option :maritime
      option :media

      next_node do |response|
        if response["earth_station"]
          question :earth_station_sat
        else
          question :sat_loc
        end
      end
    end

    radio :earth_station_sat do
      option :nsfes
      option :pes
      option :nongeo

      next_node do
        question :sat_loc
      end
    end

    radio :sat_loc do
      option :inside
      option :outside
      option :ukot_cd

      next_node do
        outcome :sat_affect_other
      end
    end

    radio :sat_affect_other do
      option :yes
      option :no

      next_node do
        question :sat_strat
      end
    end

    radio :sat_strat do
      option :yes
      option :no

      next_node do
        question :sat_debris
      end
    end

    radio :sat_debris do
      option :yes
      option :no

      next_node do
        question :sat_space_control
      end
    end

    
    radio :sat_space_control do
      option :yes
      option :no

      next_node do
        outcome :outcome_1
      end
    end




    








    outcome :outcome_1
  end
end