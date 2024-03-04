module SmartAnswer::Calculators
  class SpaceportCalculator
    RESULT_DATA = YAML.load_file(Rails.root.join("config/smart_answers/spaceport.yml")).freeze

    attr_accessor :space_activity,
                  :territorial_waters,
                  :large_rocket,
                  :foreign_airspace,
                  :marine_return


              
 
    def grouped_results
      grouped_results = filtered_results.group_by { |result| result["group"] }

      grouped_results.transform_values do |results|
        results.group_by { |result| result["topic"] }
      end
    end

    def filtered_results
      RESULT_DATA.select do |result|
        RULES[result["id"]].call(self)
      end
    end

    RULES = {
  
      
# The rules below are for launch and return.

      r19: ->(calculator) { calculator.space_activity == "launch_and_return" },
      r20: ->(calculator) { calculator.territorial_waters == "yes" },
      r21: ->(calculator) { calculator.large_rocket == "yes" },
      r22: ->(calculator) { calculator.foreign_airspace == "yes" },
      r23: ->(calculator) { calculator.foreign_airspace != "no" },
      r24: ->(calculator) { calculator.marine_return == "yes" },
      r25: ->(calculator) { calculator.space_activity == "launch_and_return" },
      r26: ->(calculator) { calculator.space_activity == "launch_and_return" },
  
# The rules below are for orbital.

    }.with_indifferent_access.freeze
  end
end









